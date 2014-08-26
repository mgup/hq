class Social::DocumentType < ActiveRecord::Base
  self.table_name = 'social_document_types'

  has_many :documents, class_name: 'Social::Document', foreign_key: :social_document_type_id

end