class Entrance::CompetitiveGroup < ActiveRecord::Base

  has_many :items, class_name: Entrance::CompetitiveGroupItem
  accepts_nested_attributes_for :items
  has_many :target_organizations, class_name: Entrance::TargetOrganizations
  accepts_nested_attributes_for :target_organizations
  has_many :test_items, class_name: Entrance::TestItem
  accepts_nested_attributes_for :test_items

  belongs_to :campaign, class_name: Entrance::Campaign
end