class ExamStudent < ActiveRecord::Base
  self.table_name = 'exam_student'

  alias_attribute :id,       :exam_student_id

  belongs_to :exam, primary_key: :exam_id, foreign_key: :exam_student_exam
  belongs_to :student, primary_key: :student_id, foreign_key: :exam_student_student

end