class ChangeEntrantRegionField < ActiveRecord::Migration
  def change
    remove_column :entrance_entrants, :aregion
    add_reference :entrance_entrants, :region, default: nil, index: true
  end
end
