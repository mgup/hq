class AddDetailsToPurchasePurchases < ActiveRecord::Migration
  def change
    add_column :purchase_purchases, :payment_type, :integer
    add_column :purchase_purchases, :purchase_introduce, :integer
    remove_column :purchase_purchases, :note, :string
  end
end
