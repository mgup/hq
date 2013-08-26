class Study::Discipline < ActiveRecord::Base
  CURRENT_STUDY_YEAR = 2013

  self.table_name = 'subject'

  alias_attribute :id,       :subject_id
  alias_attribute :name,     :subject_name
  alias_attribute :semester, :subject_semester
  alias_attribute :year,     :subject_year
  alias_attribute :brs,      :subject_brs

  belongs_to :group, foreign_key: :subject_group
  belongs_to :lead_teacher, class_name: User, foreign_key: :subject_teacher

  has_many :discipline_teacher, class_name: Study::DisciplineTeacher, primary_key: :subject_id,
           foreign_key: :subject_id, dependent: :destroy
  has_many :checkpoints, foreign_key: :checkpoint_subject
  has_many :exams, foreign_key: :exam_subject
  has_many :teachers, :through => :discipline_teacher, primary_key: :subject_id


  default_scope do
    order(subject_year: :desc, subject_semester: :desc)
  end

  scope :from_name, -> name { where("subject_name LIKE :prefix", prefix: "#{name}%")}
  scope :from_student, -> student {where(group:  student.group )}
  scope :from_group, -> group {where(group: group)}
  scope :now, -> {where(subject_year: CURRENT_STUDY_YEAR)}

  def teacher
    if subject_teacher
      User.find(subject_teacher)
    else
      User.none
    end
  end

  def has?(type)
    work = (type == 'work' ? 2 : 3)
    exams.where(exam_type: work) != []
  end

  def control
    exams.where(exam_type: [0,1,9]).first
  end

  def term
    case semester
      when 1
        'осенний семестр'
      when 2
        'весенний семестр'
    end
  end

end