class AddProfileIdToEntranceApplications < ActiveRecord::Migration
  def change
    add_column :entrance_applications, :profile_id, :integer
  end
end
