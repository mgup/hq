class AddStatusFieldToEvent < ActiveRecord::Migration
  def change
    add_column :event, :status, :integer
  end
end
