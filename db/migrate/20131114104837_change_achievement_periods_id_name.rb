class ChangeAchievementPeriodsIdName < ActiveRecord::Migration
  def change
    change_table :achievements do |t|
      t.remove_references :achievement_periods
      t.references :achievement_period, index: true
    end
  end
end
