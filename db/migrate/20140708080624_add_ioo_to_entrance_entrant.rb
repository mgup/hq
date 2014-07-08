class AddIooToEntranceEntrant < ActiveRecord::Migration
  def change
    change_table :entrance_entrants do |t|
      t.boolean :ioo, default: false
    end
  end
end
