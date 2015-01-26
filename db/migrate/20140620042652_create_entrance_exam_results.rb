class CreateEntranceExamResults < ActiveRecord::Migration
  def change
    create_table :entrance_exam_results do |t|
      t.belongs_to :entrant, null: false
      t.belongs_to :exam, null: false
      t.integer :score
      t.integer :type, null: false, default: 1
      t.string :document

      t.timestamps
    end
  end
end
