class AddDateRegistrationToPurchaseContracts < ActiveRecord::Migration
  def change
    add_column :purchase_contracts, :date_registration, :date
  end
end
