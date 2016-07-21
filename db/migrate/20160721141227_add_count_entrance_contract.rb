class AddCountEntranceContract < ActiveRecord::Migration
  def change
    add_column :entrance_contracts, :count, :integer
  end
end
