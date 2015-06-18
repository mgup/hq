class CreateEntranceAchievement < ActiveRecord::Migration
  def change
    create_table :entrance_achievements do |t|
      t.belongs_to :entrant
      t.belongs_to :entrance_achievement_type
      
      t.string     :document
      t.date       :date
    end
  end
end
