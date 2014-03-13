class AddDefaultToCuratorTaskUserStatus < ActiveRecord::Migration
  def change
    change_column :curator_task_user, :status, :integer, default: 1
  end
end
