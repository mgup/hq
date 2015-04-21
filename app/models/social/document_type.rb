class Social::DocumentType < ActiveRecord::Base
  self.table_name = 'social_document_types'

  has_many :documents, class_name: 'Social::Document', foreign_key: :social_document_type_id

  has_many :cause_document_types, class_name: 'Social::CauseDocumentType', foreign_key: :social_document_type_id
  has_many :causes, through: :cause_document_types
  
  def name_with_id
    "#{id} - #{name}"
  end
end