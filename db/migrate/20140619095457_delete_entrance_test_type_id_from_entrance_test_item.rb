class DeleteEntranceTestTypeIdFromEntranceTestItem < ActiveRecord::Migration
  def change
    remove_column :entrance_test_items, :entrance_test_type_id
  end
end
