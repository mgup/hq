class BenefitDocument::AllowEducation < ActiveRecord::Base
  self.table_name = 'allow_education_documents'

  belongs_to :benefit, class_name: 'Entrance::Benefit', foreign_key: :entrance_benefit_id
end