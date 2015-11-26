class AddSupplierIdToPurchaseContracts < ActiveRecord::Migration
  def change
    add_column :purchase_contracts, :supplier_id, :integer
  end
end
