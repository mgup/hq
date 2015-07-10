class Entrance::AchievementType < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :institution_achievement, class_name: 'InstitutionAchievement'
  belongs_to :campaign, class_name: 'Entrance::Campaign'
  
  has_many :achievements, class_name: 'Entrance::Achievement', foreign_key: :entrance_achievement_type_id

  #
  # def name
  #   name || institution_achievement.name
  # end
end
