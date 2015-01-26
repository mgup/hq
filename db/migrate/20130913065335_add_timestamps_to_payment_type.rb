class AddTimestampsToPaymentType < ActiveRecord::Migration
  def change
    change_table :finance_payment_type do |t|
      t.timestamps
    end
  end
end
