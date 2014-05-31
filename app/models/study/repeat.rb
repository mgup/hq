class Study::Repeat < ActiveRecord::Base
  TYPE_EARLY      = 1
  TYPE_FIRST      = 2
  TYPE_SECOND     = 3
  TYPE_COMMISSION = 4
  TYPE_RESPECTFUL = 5

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

  has_and_belongs_to_many :students, join_table: 'exam_student',
                          foreign_key: 'exam_student_exam',
                          association_foreign_key: 'exam_student_student_group'
  accepts_nested_attributes_for :students

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
end