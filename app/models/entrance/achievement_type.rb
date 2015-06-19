class Entrance::AchievementType < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :institution_achievement, class_name: 'InstitutionAchievement'
  belongs_to :campaign, class_name: 'Entrance::Campaign'
  
  has_many :achievements, class_name: 'Entrance::Achievement'

  #
  # def name
  #   name || institution_achievement.name
  # end
end
