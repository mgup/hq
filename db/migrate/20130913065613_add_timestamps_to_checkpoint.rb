class AddTimestampsToCheckpoint < ActiveRecord::Migration
  def change
    change_table :checkpoint do |t|
      t.timestamps
    end
  end
end
