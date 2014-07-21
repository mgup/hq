class AddIndexToCompetitiveGroupDirection < ActiveRecord::Migration
  def change
    add_index :competitive_group_items, :direction_id
  end
end
