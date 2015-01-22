class AddBookingFieldToEvent < ActiveRecord::Migration
  def change
    add_column :event, :booking, :boolean
  end
end
