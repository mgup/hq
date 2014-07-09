class AddThirdSideToEntranceContract < ActiveRecord::Migration
  def change
    change_table :entrance_contracts do |t|
      t.string :delegate_last_name
      t.string :delegate_first_name
      t.string :delegate_patronym
      t.string :delegate_address
      t.string :delegate_phone
      t.string :delegate_pseries
      t.string :delegate_pnumber
      t.string :delegate_pdepartment
      t.date   :delegate_pdate
    end
  end
end
