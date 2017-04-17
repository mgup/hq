class CreateInterview201704s < ActiveRecord::Migration
  def change
    create_table :interview201704s do |t|
      t.boolean :question1
      t.boolean :question4
      t.boolean :question6

      t.timestamps null: false
    end
  end
end
