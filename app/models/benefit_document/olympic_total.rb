class BenefitDocument::OlympicTotal < ActiveRecord::Base
  self.table_name = 'olympic_total_documents'

  belongs_to :benefit, class_name: 'Entrance::Benefit', foreign_key: :entrance_benefit_id
  has_many :subjects, class_name: 'BenefitDocument::OlympicTotalSubject', foreign_key: :olympic_total_document_id
end