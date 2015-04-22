class AddPlaceToEvent < ActiveRecord::Migration
  def change
    add_column :event, :place, :text
  end
end
