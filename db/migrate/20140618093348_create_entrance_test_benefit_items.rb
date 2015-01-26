class CreateEntranceTestBenefitItems < ActiveRecord::Migration
  def change
    create_table :entrance_test_benefit_items do |t|
      t.references :entrance_test_item, null: false
      t.references :benefit_kind, null: false
      t.boolean :is_for_all_olympics
      t.integer :min_ege_mark

      t.timestamps
      #TODO связь с olympic_levels (olympic_id (видимо, справочник 11?), level_id (???))
    end
  end
end
