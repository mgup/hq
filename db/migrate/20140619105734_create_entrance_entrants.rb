class CreateEntranceEntrants < ActiveRecord::Migration
  def change
    create_table :entrance_entrants do |t|
      t.string :last_name
      t.string :first_name
      t.string :patronym
      t.integer :gender
      t.string :snils
      t.string :information

      t.timestamps
    end
  end
end
