class CreateCuratorTaskUser < ActiveRecord::Migration
  def change
    create_table :curator_task_user do |t|
      t.integer :status
      t.boolean :accepted

      t.references :curator_task, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
