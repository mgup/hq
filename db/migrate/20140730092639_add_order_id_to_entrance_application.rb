class AddOrderIdToEntranceApplication < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.belongs_to :order
    end
  end
end
