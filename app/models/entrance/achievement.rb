class Entrance::Achievement < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :achievement_type, class_name: 'Entrance::AchievementType', foreign_key: :entrance_achievement_type_id
  belongs_to :entrant, class_name: 'Entrance::Entrant', dependent: :destroy

  def name
    achievement_type.institution_achievement.name
  end
end
