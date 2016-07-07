class BenefitDocument::Orphan < ActiveRecord::Base
  self.table_name = 'orphan_documents'

  belongs_to :benefit, class_name: 'Entrance::Benefit', foreign_key: :entrance_benefit_id
end
