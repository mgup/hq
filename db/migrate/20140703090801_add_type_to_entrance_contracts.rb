class AddTypeToEntranceContracts < ActiveRecord::Migration
  def change
    change_table :entrance_contracts do |t|
      t.integer :sides, default: 2, null: false
    end
  end
end
