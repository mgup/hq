class Study::ExamMark < ActiveRecord::Base
  self.table_name = 'mark'

  VALUE_NEYAVKA     = 1
  VALUE_2           = 2
  VALUE_3           = 3
  VALUE_4           = 4
  VALUE_5           = 5
  VALUE_ZACHET      = 6
  VALUE_NEZACHET    = 7
  VALUE_NULL        = 8  # O_o
  VALUE_NEDOPUSCHEN = 9

  alias_attribute :id,        :mark_id
  alias_attribute :value,     :mark_value

  belongs_to :exam, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :mark_exam

  scope :by_student, -> student { where(mark_student_group: student) }

end