class CreateIndexOnEntranceFields < ActiveRecord::Migration
  def change
    add_index :entrance_benefits, :application_id
    add_index :entrance_applications, :competitive_group_item_id
    add_index :competitive_group_items, :competitive_group_id
    add_index :entrance_test_items, :competitive_group_id
    add_index :entrance_test_items, :exam_id
    add_index :entrance_exam_results, :entrant_id
    add_index :entrance_exam_results, :exam_id
  end
end
