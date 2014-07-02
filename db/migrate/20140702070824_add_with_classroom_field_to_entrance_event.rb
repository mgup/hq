class AddWithClassroomFieldToEntranceEvent < ActiveRecord::Migration
  def change
    change_table :entrance_events do |t|
      t.boolean :with_classroom
    end
  end
end
