class AddNameToEntranceAchievementType < ActiveRecord::Migration
  def change
    change_table(:entrance_achievement_types) do |t|
      t.string  :name
    end
  end
end
