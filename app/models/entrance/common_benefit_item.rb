class Entrance::CommonBenefitItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  belongs_to :benefit_kind
  has_many :diplom_types, class_name: Entrance::CommonBenefitDiplomType
  accepts_nested_attributes_for :diplom_types
end