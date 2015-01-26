class AddContractInfoToTargetOrganizations < ActiveRecord::Migration
  def change
    change_table :target_organizations do |t|
      t.string :contract_number
      t.date :contract_date
    end
  end
end
