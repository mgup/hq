class Entrance::Benefit < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :application, class_name: 'Entrance::Application'#, unscoped: true
  belongs_to :benefit_kind, class_name: 'Entrance::BenefitKind'

  # ??? has_one ???
  has_one :olympic_document, class_name: 'BenefitDocument::Olympic', foreign_key: :entrance_benefit_id
  accepts_nested_attributes_for :olympic_document, allow_destroy: true
  has_one :olympic_total_document, class_name: 'BenefitDocument::OlympicTotal', foreign_key: :entrance_benefit_id
  accepts_nested_attributes_for :olympic_total_document, allow_destroy: true
  has_one :medical_disability_document, class_name: 'BenefitDocument::MedicalDisability', foreign_key: :entrance_benefit_id
  accepts_nested_attributes_for :medical_disability_document, allow_destroy: true
  has_one :allow_education_document, class_name: 'BenefitDocument::AllowEducation', foreign_key: :entrance_benefit_id
  accepts_nested_attributes_for :allow_education_document, allow_destroy: true
  has_one :orphan_document, class_name: 'BenefitDocument::Orphan', foreign_key: :entrance_benefit_id
  accepts_nested_attributes_for :orphan_document, allow_destroy: true
  has_one :custom_document, class_name: 'BenefitDocument::Custom', foreign_key: :entrance_benefit_id
  accepts_nested_attributes_for :custom_document, allow_destroy: true

  def document_reason
    if olympic_document
      'Победитель/призёр олипиады школьников'
    elsif olympic_total_document
      'Победитель/призёр всероссийской олипиады школьников'
    elsif medical_disability_document
      'Медицинские показатели'
    elsif orphan_document
      'Сирота'
    else
      'Иные причины'
    end
  end

  def document_reason_type
    if olympic_document
      :olympic
    elsif olympic_total_document
      :olympic_total
    elsif medical_disability_document
      :medicine
    elsif orphan_document
      :orphan
    else custom_document
      :custom
    end
  end
end
