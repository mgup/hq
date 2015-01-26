class CreateEntranceContracts < ActiveRecord::Migration
  def change
    create_table :entrance_contracts do |t|
      t.string :number
      t.belongs_to :application

      t.timestamps
    end
  end
end
