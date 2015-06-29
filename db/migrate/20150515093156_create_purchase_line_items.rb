class CreatePurchaseLineItems < ActiveRecord::Migration
  def change
    create_table :purchase_line_items, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :purchase_id # номер заявки
      t.integer :good_id # товар
      t.column :measure, :integer # ед. измерения
      t.float :start_price # начальная цена
      t.float :total_price # планируемая сумма
      t.float :count # количество
      t.column :period, :integer # период
      t.date :p_start_date # начало периода
      t.date :p_end_date # конец периода
      t.integer :supplier_id # поставщик, м.б. не определен
      t.column :published, :integer # опубликован
      t.column :contracted, :integer # законтрактирован
      t.column :delivered, :integer # поставлен
      t.column :paid, :integer # оплачен
    end
  end
end
