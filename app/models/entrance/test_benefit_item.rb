class Entrance::TestBenefitItem < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  belongs_to :test_item, class_name: Entrance::TestItem
end