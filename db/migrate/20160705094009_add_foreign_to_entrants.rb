class AddForeignToEntrants < ActiveRecord::Migration
  def change
    add_column :entrance_entrants, :foreign, :boolean, default: false
  end
end
