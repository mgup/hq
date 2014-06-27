class CreateEntranceMinScore < ActiveRecord::Migration
  def change
    create_table :entrance_min_scores do |t|
      t.integer :score
      t.references :campaign, null: false
      t.references :direction, null: false
      t.references :education_source, null: false
      t.references :use_subject, null: false
      t.timestamps
    end
  end
end
