class AddTimestampsToDirection < ActiveRecord::Migration
  def change
    change_table :directions do |t|
      t.timestamps
    end
  end
end
