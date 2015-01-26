class AddYearToEntranceCheckResult < ActiveRecord::Migration
  def change
    change_table :entrance_use_check_results do |t|
      t.integer :year
    end
  end
end
