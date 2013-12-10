class AddTimestampsToOrder < ActiveRecord::Migration
  def change
    change_table :order do |t|
      t.timestamps
    end
  end
end
