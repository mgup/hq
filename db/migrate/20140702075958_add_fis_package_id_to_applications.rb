class AddFisPackageIdToApplications < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.integer :package_id
    end
  end
end
