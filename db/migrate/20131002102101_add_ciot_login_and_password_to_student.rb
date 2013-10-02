class AddCiotLoginAndPasswordToStudent < ActiveRecord::Migration
  def change
    add_column :student_group, :ciot_login, :string
    add_column :student_group, :ciot_password, :string
  end
end
