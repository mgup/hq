class AddDelegateKsDelegateBankToEntranceContract < ActiveRecord::Migration
  def change
    add_column :entrance_contracts, :delegate_ks, :string
    add_column :entrance_contracts, :delegate_bank, :string
  end
end
