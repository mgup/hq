class CreateCuratorTask < ActiveRecord::Migration
  def change
    create_table :curator_task do |t|
      t.string        :name, null: false
      t.text          :description
      t.integer       :sratus

      t.timestamps
      t.references :curator_task_type, index: true
    end
  end
end
