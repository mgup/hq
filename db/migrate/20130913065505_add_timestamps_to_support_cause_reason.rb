class AddTimestampsToSupportCauseReason < ActiveRecord::Migration
  def change
    change_table :support_cause_reason do |t|
      t.timestamps
    end
  end
end
