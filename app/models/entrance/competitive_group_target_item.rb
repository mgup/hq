class Entrance::CompetitiveGroupTargetItem < ActiveRecord::Base

  belongs_to :target_organization, class_name: Entrance::TargetOrganization
  belongs_to :direction
  belongs_to :education_level
end