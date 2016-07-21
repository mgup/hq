class AddStatusToEntranceContract < ActiveRecord::Migration
  def change
    add_column :entrance_contracts, :status, :integer, default: 1
  end
end
