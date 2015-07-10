class AddVisibleToEntranceEntrants < ActiveRecord::Migration
  def change
    change_table :entrance_entrants do |t|
      t.boolean :visible, default: true
    end
  end
end
