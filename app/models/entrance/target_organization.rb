class Entrance::TargetOrganization < ActiveRecord::Base
  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
end