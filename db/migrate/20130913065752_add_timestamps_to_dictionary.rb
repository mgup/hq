class AddTimestampsToDictionary < ActiveRecord::Migration
  def change
    change_table :dictionary do |t|
      t.timestamps
    end
  end
end
