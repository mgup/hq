class ChangeEntranceContract < ActiveRecord::Migration
  def change
    change_table :entrance_contracts do |t|
      t.string :delegate_mobile
      t.string :delegate_fax
      t.string :delegate_inn
      t.string :delegate_kpp
      t.string :delegate_ls
      t.string :delegate_bik
      t.string :delegate_position
    end
  end
end
