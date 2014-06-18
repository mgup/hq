class Entrance::TestItem < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  has_many :benefit_items, class_name: Entrance::TestBenefitItem
end