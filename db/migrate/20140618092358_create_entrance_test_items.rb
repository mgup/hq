class CreateEntranceTestItems < ActiveRecord::Migration
  def change
    create_table :entrance_test_items do |t|
      t.references :competitive_group, null: false
      t.references :entrance_test_type, null: false

      t.string :form
      t.integer :min_score
      t.integer :entrance_test_priority

      # Зачем делать связь один к одному? EntranceTestSubject
      t.references :use_subject
      t.string :subject_name

      t.timestamps
    end
  end
end
