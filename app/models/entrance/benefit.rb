class Entrance::Benefit < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :application, class_name: 'Entrance::Application'
  belongs_to :benefit_kind, class_name: 'Entrance::BenefitKind'
end
