class ChangeEntranceEvent < ActiveRecord::Migration
  def change
    change_column :entrance_events, :date, :datetime
  end
end
