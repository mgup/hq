class Study::Exam < ActiveRecord::Base
  TYPE_TEST             = 0
  TYPE_GRADED_TEST      = 9
  TYPE_EXAMINATION      = 1

  TYPE_SEMESTER_WORK    = 2
  TYPE_SEMESTER_PROJECT = 3

  self.table_name = 'exam'

  alias_attribute :id,       :exam_id
  alias_attribute :type,     :exam_type
  alias_attribute :date,     :exam_date
  alias_attribute :weight,   :exam_weight
  alias_attribute :parent,   :exam_parent
  alias_attribute :repeat,   :exam_repeat

  belongs_to :discipline, class_name: Study::Discipline, primary_key: :subject_id, foreign_key: :exam_subject
  belongs_to :group, primary_key: :group_id, foreign_key: :exam_group

  #has_many :exam_students, class_name: Study::ExamStudents, foreign_key: :exam_student_exam

  has_many :exammarks, class_name: Study::ExamMark, foreign_key: :mark_exam

  validates :type, presence: true, inclusion: { in: [0,
                                                     1,
                                                     self::TYPE_SEMESTER_WORK,
                                                     self::TYPE_SEMESTER_PROJECT,
                                                     9] }
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 20,
                                                     less_than_or_equal_to: 80 }

  def name
    case type
      when TYPE_TEST
        'Зачёт'
      when TYPE_GRADED_TEST
        'Дифференцированный зачёт'
      when TYPE_EXAMINATION
        'Экзамен'
      when TYPE_SEMESTER_WORK
        'Курсовая работа'
      when TYPE_SEMESTER_PROJECT
        'Курсовой проект'
    end
  end
end