class AddTimestampsToSelect < ActiveRecord::Migration
  def change
    change_table :optional_select do |t|
      t.timestamps
    end
  end
end
