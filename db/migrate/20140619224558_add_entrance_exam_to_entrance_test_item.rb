class AddEntranceExamToEntranceTestItem < ActiveRecord::Migration
  def change
    add_column :entrance_test_items, :exam_id, :integer
  end
end
