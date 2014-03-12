class CreateCuratorTaskType < ActiveRecord::Migration
  def change
    create_table :curator_task_type do |t|
      t.string        :name, null: false
      t.text          :description
      t.timestamps
    end
  end
end
