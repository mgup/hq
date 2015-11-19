class CreatePurchaseContractItems < ActiveRecord::Migration
  def change
    create_table :purchase_contract_items do |t|
      t.integer :line_item_id, null: false
      t.integer :contract_id, null: false
      t.integer :item_count
      t.decimal :total_price, precision: 10, scale: 2
      t.integer :contract_time
      t.timestamps null: false
    end
  end
end
