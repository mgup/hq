class AddDeviseFieldsToStudent < ActiveRecord::Migration
  def change
    add_column :student_group, :reset_password_token, :string
    add_column :student_group, :reset_password_sent_at, :datetime
    add_column :student_group, :remember_created_at, :datetime
    add_column :student_group, :sign_in_count, :integer
    add_column :student_group, :current_sign_in_at, :datetime
    add_column :student_group, :last_sign_in_at, :datetime
    add_column :student_group, :current_sign_in_ip, :string
    add_column :student_group, :last_sign_in_ip, :string
  end
end
