class Entrance::CommonBenefitDiplomType < ActiveRecord::Base
  self.table_name = 'common_benefit_item_olympic_diplom_types'
  belongs_to :common_benefit, class_name: Entrance::CommonBenefitItem
end