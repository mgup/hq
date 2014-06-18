class Entrance::CompetitiveGroupItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitveGroup
  belongs_to :direction
  belongs_to :education_level
end