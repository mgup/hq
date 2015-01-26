class BenefitDocument::Custom < ActiveRecord::Base
  self.table_name = 'custom_documents'

  belongs_to :benefit, class_name: 'Entrance::Benefit', foreign_key: :entrance_benefit_id
end