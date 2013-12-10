class AddTimestampsToGroup < ActiveRecord::Migration
  def change
    change_table :group do |t|
      t.timestamps
    end
  end
end
