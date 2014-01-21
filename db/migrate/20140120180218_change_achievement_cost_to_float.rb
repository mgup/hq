class ChangeAchievementCostToFloat < ActiveRecord::Migration
  def change
    change_column :achievements, :cost, :float
  end
end
