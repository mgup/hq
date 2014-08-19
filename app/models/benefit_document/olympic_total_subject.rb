class BenefitDocument::OlympicTotalSubject < ActiveRecord::Base
  self.table_name = 'olympic_total_document_subjects'

  belongs_to :subject, class_name: 'Use::Subject' #ведь подразумевается эта таблица?..
  belongs_to :olympic_total_document, class_name: 'BenefitDocument::OlympicTotal'
end