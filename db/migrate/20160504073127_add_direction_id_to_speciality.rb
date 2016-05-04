class AddDirectionIdToSpeciality < ActiveRecord::Migration
  def change
    add_column :speciality, :direction_id, :integer
  end
end
