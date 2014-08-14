class AddPrikladnoyToEntranceApplication < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.boolean :prikladnoy, default: false
    end
  end
end
