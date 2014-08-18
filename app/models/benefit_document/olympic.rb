class BenefitDocument::Olympic < ActiveRecord::Base
  self.table_name = 'olympic_documents'

  belongs_to :benefit, class_name: 'Entrance::Benefit', foreign_key: :entrance_benefit_id
end