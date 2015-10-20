class CreatePurchaseContracts < ActiveRecord::Migration
  def change
    create_table :purchase_contracts do |t|
      t.string :number, null: false
      t.date :gate_registration
      t.integer :total_price
      t.timestamps null: false
    end
  end
end
