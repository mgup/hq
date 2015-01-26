class AddCompetitiveGroupTargetItemToApplication < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.belongs_to :competitive_group_target_item
    end
  end
end
