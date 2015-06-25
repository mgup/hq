class CreatePurchaseSuppliers < ActiveRecord::Migration
  def change
    create_table :purchase_suppliers, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name # поставщик
      t.integer :inn, limit: 8 # инн
      t.string :address # адрес
      t.string :phone # телефон
    end
  end
end
