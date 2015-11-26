class AddDepartmentIdToPurchaseGoods < ActiveRecord::Migration
  def change
    add_column :purchase_goods, :department_id, :integer
  end
end
