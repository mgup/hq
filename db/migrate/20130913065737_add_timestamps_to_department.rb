class AddTimestampsToDepartment < ActiveRecord::Migration
  def change
    change_table :department do |t|
      t.timestamps
    end
  end
end
