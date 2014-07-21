class ChangeStudentGroupDefaults < ActiveRecord::Migration
  def change
    change_column_null :student_group, :student_group_oldstudent, true
    change_column_null :student_group, :student_group_oldgroup, true
    change_column_null :student, :student_oldid, true
    change_column_null :student, :student_oldperson, true
  end
end
