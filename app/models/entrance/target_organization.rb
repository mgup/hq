class Entrance::TargetOrganization < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  has_many :items, class_name: Entrance::CompetitiveGroupTargetItem
  accepts_nested_attributes_for :items
end