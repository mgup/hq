class CreateCompetitiveGroupTargetItem < ActiveRecord::Migration
  def change
    create_table :competitive_group_target_items do |t|
      t.references :target_organization, null: false
      t.integer :number_target_o
      t.integer :number_target_oz
      t.integer :number_target_z

      t.references :education_level, null: false
      t.references :direction, null: false
      t.timestamps
    end
  end
end
