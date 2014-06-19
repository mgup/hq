class Entrance::TestBenefitDiplomType < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name = 'entrance_test_benefit_item_olympic_diplom_types'

  belongs_to :test_benefit, class_name: Entrance::TestBenefitItem
end