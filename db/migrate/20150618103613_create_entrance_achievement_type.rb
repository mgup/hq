class CreateEntranceAchievementType < ActiveRecord::Migration
  def change
    create_table :entrance_achievement_types do |t|
      t.belongs_to :campaign
      t.belongs_to :institution_achievement
      
      t.integer :max_ball
    end
  end
end
