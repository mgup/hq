class AddTimestampsToSupportReason < ActiveRecord::Migration
  def change
    change_table :support_reason do |t|
      t.timestamps
    end
  end
end
