class CreateEntranceTestTypes < ActiveRecord::Migration
  def change
    create_table :entrance_test_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
