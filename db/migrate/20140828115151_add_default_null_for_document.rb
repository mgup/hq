class AddDefaultNullForDocument < ActiveRecord::Migration
  def change
    change_column_null :document_student, :student_oldid, true
    change_column_null :document_student, :student_oldperson, true

    change_column_null :document_student_group, :student_group_oldstudent, true
    change_column_null :document_student_group, :student_group_oldgroup, true
  end
end
