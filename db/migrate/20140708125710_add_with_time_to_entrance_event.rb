class AddWithTimeToEntranceEvent < ActiveRecord::Migration
  def change
    change_table :entrance_events do |t|
      t.boolean :with_time, default: false
    end
  end
end
