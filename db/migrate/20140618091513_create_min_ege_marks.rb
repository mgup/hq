class CreateMinEgeMarks < ActiveRecord::Migration
  def change
    create_table :min_ege_marks do |t|
      t.references :common_benefit_item, null: false
      t.references :use_subject, null: false
      t.integer :min_mark

      t.timestamps
    end
  end
end
