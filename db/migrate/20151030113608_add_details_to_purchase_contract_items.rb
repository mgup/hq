class AddDetailsToPurchaseContractItems < ActiveRecord::Migration
  def change
    remove_column :purchase_contract_items, :start_date, :date
    remove_column :purchase_contract_items, :end_date, :date
    remove_column :purchase_contract_items, :price, :integer
    remove_column :purchase_contracts, :gate_registration, :date

    add_column :purchase_contracts, :date_registration, :date
    add_column :purchase_contract_items, :contract_time, :integer
  end
end
