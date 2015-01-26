class AddPasswordToStudent < ActiveRecord::Migration
  def change
    add_column :student_group, :encrypted_password, :string
    add_timestamps :student_group
  end
end
