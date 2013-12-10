class AddTimestampsToSupportCause < ActiveRecord::Migration
  def change
    change_table :support_cause do |t|
      t.timestamps
    end
  end
end
