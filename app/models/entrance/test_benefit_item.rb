class Entrance::TestBenefitItem < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  belongs_to :test_item, class_name: Entrance::TestItem, foreign_key: :entrance_test_item_id
  belongs_to :benefit_kind
  has_many :diplom_types, class_name: Entrance::TestBenefitDiplomType, foreign_key: :entrance_test_benefit_item_id
  accepts_nested_attributes_for :diplom_types
end