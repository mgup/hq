class CreatePurchasePurchases < ActiveRecord::Migration
  def change
    create_table :purchase_purchases, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :dep_id # департамент
      t.string :number # номер
      t.date :date_registration # дата регистрации
      t.column :status, :integer # статус выполнения
      t.string :note # примечание
    end
  end
end
