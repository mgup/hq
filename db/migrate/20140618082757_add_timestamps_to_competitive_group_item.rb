class AddTimestampsToCompetitiveGroupItem < ActiveRecord::Migration
  def change
    change_table :competitive_group_items do |t|
      t.timestamps
    end
  end
end
