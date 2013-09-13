class AddTimestampsToSupportOptions < ActiveRecord::Migration
  def change
    change_table :support_options do |t|
      t.timestamps
    end
  end
end
