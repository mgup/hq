class AddTimestampsToPrice < ActiveRecord::Migration
  def change
    change_table :finance_price do |t|
      t.timestamps
    end
  end
end
