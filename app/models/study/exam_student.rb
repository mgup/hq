class Study::ExamStudent < ActiveRecord::Base
  self.table_name = 'exam_student'

  alias_attribute :id,        :exam_student_id

  belongs_to :exam, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :exam_student_exam
  belongs_to :student, class_name: Student, primary_key: :student_group_id, foreign_key: :exam_student_student_group
  belongs_to :person, class_name: Person, primary_key: :student_id, foreign_key: :exam_student_student

end