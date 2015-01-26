class ChangeActivityCreditDefault < ActiveRecord::Migration
  def change
    change_column :activities, :credit, :decimal, precision: 5, scale: 1, default: 0
  end
end
