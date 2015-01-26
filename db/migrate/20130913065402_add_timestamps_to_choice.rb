class AddTimestampsToChoice < ActiveRecord::Migration
  def change
    change_table :optional do |t|
      t.timestamps
    end
  end
end
