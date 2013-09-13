class AddTimestampsToPayment < ActiveRecord::Migration
  def change
    change_table :finance_payment do |t|
      t.timestamps
    end
  end
end
