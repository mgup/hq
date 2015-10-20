class RemoveDetailsFromPurchaseLineItems < ActiveRecord::Migration
  def change
    remove_column :purchase_line_items, :measure, :integer
    remove_column :purchase_line_items, :start_price, :float
    remove_column :purchase_line_items, :total_price, :float
    remove_column :purchase_line_items, :count, :float
    remove_column :purchase_line_items, :p_start_date, :date
    remove_column :purchase_line_items, :p_end_date, :date
    add_column :purchase_line_items, :planned_sum, :integer
  end
end
