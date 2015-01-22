class AddFieldsToEntrant < ActiveRecord::Migration
  def change
    change_table :entrance_entrants do |t|
      t.date   :birthday, null: false
      t.string :birth_place, null: false

      t.string :pseries
      t.string :pnumber, null: false
      t.string :pdepartment, null: false
      t.date   :pdate, null: false

      t.integer :acountry, default: 0, null: false
      t.string  :azip, null: false
      t.string  :aregion
      t.string  :aaddress, null: false
      t.string  :phone, null: false

      t.integer :military_service, default: 1, null: false
    end
  end
end
