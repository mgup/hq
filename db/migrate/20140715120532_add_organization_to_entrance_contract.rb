class AddOrganizationToEntranceContract < ActiveRecord::Migration
  def change
    change_table :entrance_contracts do |t|
      t.string :delegate_organization
    end
  end
end
