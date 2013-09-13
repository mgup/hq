class AddTimestampsToMark < ActiveRecord::Migration
  def change
    change_table :checkpoint_mark do |t|
      t.timestamps
    end
  end
end
