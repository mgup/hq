class AddAgreeToEntranceApplication < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.boolean :agree
    end
  end
end
