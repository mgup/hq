class AddScoreToEntranceAchievement < ActiveRecord::Migration
  def change
    add_column :entrance_achievements, :score, :integer
  end
end
