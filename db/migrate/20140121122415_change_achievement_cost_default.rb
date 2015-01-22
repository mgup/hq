class ChangeAchievementCostDefault < ActiveRecord::Migration
  def change
    change_column_default :achievements, :cost, 0
  end
end
