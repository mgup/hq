class CreateCompetitiveGroupItemProfiles < ActiveRecord::Migration
  def change
    create_table :competitive_group_item_profiles do |t|
      t.references :item, index: true
      t.references :profile, index: true

      t.timestamps
    end
  end
end
