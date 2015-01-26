class AddCitizenshipToEntrant < ActiveRecord::Migration
  def change
    add_column :entrance_entrants, :citizenship, :integer,
               null: false, default: 1
  end
end
