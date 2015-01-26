class AddTimestampsToActivity < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.timestamps
    end
  end
end
