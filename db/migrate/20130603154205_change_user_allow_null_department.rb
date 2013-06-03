class ChangeUserAllowNullDepartment < ActiveRecord::Migration
  def change
    change_table :user do |t|
      t.change :user_department, :integer, null: true, default: nil
    end
  end
end
