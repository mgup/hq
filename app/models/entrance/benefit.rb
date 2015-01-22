class Entrance::Benefit < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :application, class_name: 'Entrance::Application'
  belongs_to :benefit_kind, class_name: 'Entrance::BenefitKind'

  # ??? has_one ???
  has_one :olympic_document, class_name: 'BenefitDocument::Olympic', foreign_key: :entrance_benefit_id
  has_one :olympic_total_document, class_name: 'BenefitDocument::OlympicTotal', foreign_key: :entrance_benefit_id
  has_one :medical_disability_document, class_name: 'BenefitDocument::MedicalDisability', foreign_key: :entrance_benefit_id
  has_one :allow_education_document, class_name: 'BenefitDocument::AllowEducation', foreign_key: :entrance_benefit_id
  has_one :custom_document, class_name: 'BenefitDocument::Custom', foreign_key: :entrance_benefit_id
end
