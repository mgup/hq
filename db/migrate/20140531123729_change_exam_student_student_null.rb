class ChangeExamStudentStudentNull < ActiveRecord::Migration
  def change
    change_column_null 'exam_student', 'exam_student_student', true
  end
end
