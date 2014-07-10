class ChangeStudentPhoneLength < ActiveRecord::Migration
  def change
    change_column :student, :student_phone_home, :string
    change_column :student, :student_phone_mobile, :string
  end
end
