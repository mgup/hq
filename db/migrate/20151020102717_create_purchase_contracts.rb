class CreatePurchaseContracts < ActiveRecord::Migration
  def change
    create_table :purchase_contracts do |t|
      t.string :number, null: false
      t.date :gate_registration
      t.decimal :total_price,  precision: 10, scale: 2
      t.timestamps null: false
    end
  end
end
