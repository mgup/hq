class AddIsPayedToEntranceApplication < ActiveRecord::Migration
  def change
    add_column :entrance_applications, :is_payed, :boolean
  end
end
