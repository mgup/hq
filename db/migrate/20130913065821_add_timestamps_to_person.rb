class AddTimestampsToPerson < ActiveRecord::Migration
  def change
    change_table :student do |t|
      t.timestamps
    end
  end
end
