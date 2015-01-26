class ChangeAchievements < ActiveRecord::Migration
  def change
    change_table :achievements do |t|
      t.integer :value
      t.decimal :cost, precision: 5, scale: 1
      t.integer :status, default: 1
    end
  end
end
