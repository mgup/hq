class RemoveSupplierIdFromPurchaseLineItems < ActiveRecord::Migration
  def change
    remove_column :purchase_line_items, :supplier_id
  end
end
