class AddTownTypeIdToEntrant < ActiveRecord::Migration
  def change
    add_column :entrants, :town_type_id, :integer, null: true
  end
end
