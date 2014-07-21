class AddFieldsToEntrant2 < ActiveRecord::Migration
  def change
    change_table :entrance_entrants do |t|
      t.boolean :foreign_institution, default: false
      t.string :institution, null: false
      t.integer :graduation_year, null: false
      t.string :certificate_number, null: false
      t.date :certificate_date, null: false

      t.integer :foreign_language
      t.boolean :need_hostel, default: true
    end
  end
end
