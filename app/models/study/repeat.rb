class Study::Repeat < ActiveRecord::Base
  TYPE_EARLY      = 1
  TYPE_FIRST      = 2
  TYPE_SECOND     = 3
  TYPE_COMMISSION = 4
  TYPE_RESPECTFUL = 5

  TYPE_TEST             = 0
  TYPE_GRADED_TEST      = 9
  TYPE_EXAMINATION      = 1

  TYPE_SEMESTER_WORK    = 2
  TYPE_SEMESTER_PROJECT = 3

  TYPE_PRACTICE = 4
  TYPE_DIPLOMA_PRACTICE = 5
  TYPE_FINAL_EXAM = 6
  TYPE_EXAM_COMMISSION_1 = 7
  TYPE_EXAM_COMMISSION_2 = 8

  TYPE_VALIDATION = 10

  TYPE_OPTIONS = [
    ['досрочно',             TYPE_EARLY],
    ['первая пересдача',     TYPE_FIRST],
    ['вторая пересдача',     TYPE_SECOND],
    ['комиссия',             TYPE_COMMISSION],
    ['уважительная причина', TYPE_RESPECTFUL]
  ]

  self.table_name = 'exam'

  alias_attribute :id,   :exam_id
  alias_attribute :date, :exam_date
  alias_attribute :type, :exam_repeat

  belongs_to :exam, class_name: 'Study::Exam', foreign_key: :exam_parent
  belongs_to :department, class_name: 'Department', foreign_key: :cafedra, primary_key: :department_id

  has_and_belongs_to_many :students, join_table: 'exam_student',
                          foreign_key: 'exam_student_exam',
                          association_foreign_key: 'exam_student_student_group'
  accepts_nested_attributes_for :students

  has_many :commission_teachers, -> { where('head = 0') }, class_name: 'Study::ExamUser', primary_key: :exam_id,
           foreign_key: :exam_id, dependent: :destroy
  accepts_nested_attributes_for :commission_teachers, allow_destroy: true

  has_one :commission_head, -> { where('head = 1') },
          class_name: 'Study::ExamUser', primary_key: :exam_id, foreign_key: :exam_id, dependent: :destroy
  accepts_nested_attributes_for :commission_head, allow_destroy: true


  # Эта связь остаётся только для совместимости со старыми персональными ведомостями
  # на пересдачу. Она используется в views/repeats/index.html.erb. Она запрещена
  # для создания новых индивидуальных ведомостей. Все ведомости на пересдачу должны быть
  # «групповыми». Просто в них может быть не несколько студентов, а только один.
  belongs_to :deprecated_student, class_name: Student, foreign_key: :exam_student_group

  before_validation do |repeat|
    [:type, :subject].each do |field|
      if repeat.send("exam_#{field}").nil?
        repeat.send("exam_#{field}=", repeat.exam.send("exam_#{field}"))
      end
    end
  end

  default_scope do
    order(exam_date: :desc, exam_id: :desc)
  end

  def is_group?
    exam_group.present?
  end

  def is_personal?
    exam_group.blank?
  end

  def repeat_type
    case exam_repeat
    when TYPE_FIRST
      'первая пересдача'
    when TYPE_SECOND
      'вторая пересдача'
    when TYPE_COMMISSION
      'комиссия'
    when TYPE_EARLY
      'досрочно'
    when TYPE_RESPECTFUL
      'уважительная причина'
    end
  end

  def rname
    case exam_type
    when TYPE_TEST
      'зачёт'
    when TYPE_GRADED_TEST
      'дифференцированный зачёт'
    when TYPE_EXAMINATION
      'экзамен'
    else
      'защита'
    end
  end
end
