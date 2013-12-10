class ConnectActivityWithCreditType < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.references :activity_credit_type, index: true
    end
  end
end
