class CreatePurchaseContractItems < ActiveRecord::Migration
  def change
    create_table :purchase_contract_items do |t|
      t.integer :line_item_id, null: false
      t.integer :contract_id, null: false
      t.integer :price
      t.integer :item_count
      t.integer :total_price
      t.date :start_date
      t.date :end_date
      t.timestamps null: false
    end
  end
end
