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

  has_many :discipline_teachers, class_name: Study::DisciplineTeacher,
           primary_key: :subject_id, foreign_key: :subject_id, dependent: :destroy
  accepts_nested_attributes_for :discipline_teachers, allow_destroy: true, reject_if: proc { |attrs| attrs[:teacher_id].blank? }

  has_many :assistant_teachers, through: :discipline_teachers

  has_many :lectures, -> { where(checkpoint_type: Study::Checkpoint::TYPE_LECTURE).order(:checkpoint_date) },
           class_name: Study::Checkpoint, foreign_key: :checkpoint_subject, dependent: :destroy
  accepts_nested_attributes_for :lectures, allow_destroy: true

  has_many :seminars, -> { where(checkpoint_type: Study::Checkpoint::TYPE_SEMINAR).order(:checkpoint_date) },
           class_name: Study::Checkpoint, foreign_key: :checkpoint_subject, dependent: :destroy
  accepts_nested_attributes_for :seminars, allow_destroy: true

  has_many :checkpoints, -> { where(checkpoint_type: Study::Checkpoint::TYPE_CHECKPOINT).order(:checkpoint_date) },
           class_name: Study::Checkpoint, foreign_key: :checkpoint_subject, dependent: :destroy
  accepts_nested_attributes_for :checkpoints, allow_destroy: true

  has_many :classes, -> { order(:checkpoint_date) }, class_name: Study::Checkpoint, foreign_key: :checkpoint_subject

  has_many :exams, class_name: Study::Exam, foreign_key: :exam_subject, dependent: :destroy
  accepts_nested_attributes_for :exams

  has_many :final_exams, -> { where(exam_type: [Study::Exam::TYPE_TEST, Study::Exam::TYPE_GRADED_TEST, Study::Exam::TYPE_EXAMINATION]) }, class_name: Study::Exam, foreign_key: :exam_subject, dependent: :destroy
  accepts_nested_attributes_for :final_exams

  validates :name, presence: true
  validates :year, presence: true, numericality: { greater_than: 2012, less_than: 2020 }
  validates :semester, presence: true, inclusion: { in: [1,2] }
  validates :lead_teacher, presence: true
  validates :group, presence: true
  validates :final_exams, presence: true
  validate  :sum_of_checkpoints_max_values_should_be_80
  validate  :sum_of_checkpoints_min_values_should_be_44

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

  private

  def sum_of_checkpoints_max_values_should_be_80
    return true if checkpoints.length == 0
    max_sum = 0
    checkpoints.each do |c|
      max_sum += c.max unless c.marked_for_destruction?
    end
    if 80 != max_sum
      errors.add(:'checkpoints.max',
                 "Сумма максимальных баллов должна равняться 80. У вас — #{max_sum}.")
    end
  end

  def sum_of_checkpoints_min_values_should_be_44
    return true if checkpoints.length == 0
    min_sum = 0
    checkpoints.each do |c|
      min_sum += c.min unless c.marked_for_destruction?
    end
    if 44 != min_sum
      errors.add(:'checkpoints.min',
                 "Сумма минимальных зачётных баллов должна равняться 44. У вас — #{min_sum}.")
    end
  end
end