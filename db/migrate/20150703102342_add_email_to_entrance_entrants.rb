class AddEmailToEntranceEntrants < ActiveRecord::Migration
  def change
    add_column :entrance_entrants, :email, :string
  end
end
