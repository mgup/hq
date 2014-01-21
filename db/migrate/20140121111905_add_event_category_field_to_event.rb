class AddEventCategoryFieldToEvent < ActiveRecord::Migration
  def change
    change_table :event do |t|
      t.integer :event_category_id, index: true
    end
  end
end
