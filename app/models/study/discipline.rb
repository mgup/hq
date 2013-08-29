class Study::Discipline < ActiveRecord::Base
  STUDY_START = { 2013 => { 1 => Date.new(2013,  9,  4) } }
  STUDY_END   = { 2013 => { 1 => Date.new(2013, 12, 30) } }
  CURRENT_STUDY_YEAR  = 2013
  CURRENT_STUDY_TERM  = 1

  self.table_name = 'subject'

  alias_attribute :id,       :subject_id
  alias_attribute :name,     :subject_name
  alias_attribute :semester, :subject_semester
  alias_attribute :year,     :subject_year
  alias_attribute :brs,      :subject_brs

  belongs_to :group, foreign_key: :subject_group
  belongs_to :lead_teacher, class_name: User, foreign_key: :subject_teacher

  has_many :checkpoints, foreign_key: :checkpoint_subject

  has_many :exams, class_name: Study::Exam, foreign_key: :exam_subject, dependent: :destroy
  accepts_nested_attributes_for :exams

  has_many :discipline_teachers, class_name: Study::DisciplineTeacher,
           primary_key: :subject_id, foreign_key: :subject_id, dependent: :delete_all
  accepts_nested_attributes_for :discipline_teachers, reject_if: proc { |attrs| attrs[:teacher_id].blank? }

  has_many :assistant_teachers, through: :discipline_teachers

  validates :name, presence: true
  validates :year, presence: true, numericality: { greater_than: 2012, less_than: 2020 }
  validates :semester, presence: true, inclusion: { in: [1,2] }
  validates :lead_teacher, presence: true
  validates :group, presence: true

  default_scope do
    order(subject_year: :desc, subject_semester: :desc)
  end

  scope :from_name, -> name { where('subject_name LIKE :prefix', prefix: "#{name}%")}
  scope :from_student, -> student {where(subject_group:  student.group )}
  scope :from_group, -> group {where(subject_group: group)}
  scope :now, -> {where(subject_year: CURRENT_STUDY_YEAR, subject_semester: CURRENT_STUDY_TERM)}
  scope :include_teacher, -> user {
    includes(:assistant_teachers)
    .where('subject_teacher = ? OR subject_teacher.teacher_id = ?', user.id, user.id)
  }

  def has?(type)
    work = (type == 'work' ? 2 : 3)
    exams.where(exam_type: work) != []
  end

  def control
    exams.where(exam_type: [0,1,9]).first
  end

  def is_active?
    case CURRENT_STUDY_TERM
      when 1
        year == CURRENT_STUDY_YEAR || (year == CURRENT_STUDY_YEAR - 1 && semester == 2)
      when 2
        year == CURRENT_STUDY_YEAR
    end
  end

  def add_semester_work
    exams.create(exam_type: Study::Exam::TYPE_SEMESTER_WORK)
    save!
  end
  def add_semester_project
    exams.create(exam_type: Study::Exam::TYPE_SEMESTER_PROJECT)
  end
end