class AddTimestampsToPosition < ActiveRecord::Migration
  def change
    change_table :acl_position do |t|
      t.timestamps
    end
  end
end
