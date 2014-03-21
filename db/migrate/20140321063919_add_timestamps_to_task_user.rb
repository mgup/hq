class AddTimestampsToTaskUser < ActiveRecord::Migration
  def change
    change_table :curator_task_user do |t|
      t.timestamps
    end
  end
end
