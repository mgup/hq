class CreatePurchaseGoods < ActiveRecord::Migration
  def change
    create_table :purchase_goods, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name # наименование
      t.string :demand # обоснование
    end
  end
end
