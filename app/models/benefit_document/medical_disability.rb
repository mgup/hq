class BenefitDocument::MedicalDisability < ActiveRecord::Base
  self.table_name = 'medical_disability_documents'

  enum kind: { medical: 1, disability: 2 }
  belongs_to :benefit, class_name: 'Entrance::Benefit', foreign_key: :entrance_benefit_id
end