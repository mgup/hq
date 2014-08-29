class Social::CauseDocumentType < ActiveRecord::Base
  self.table_name = 'support_cause_document_types'

  belongs_to :document_type, class_name: 'Social::DocumentType', foreign_key: :social_document_type_id
  belongs_to :cause, class_name: 'My::SupportCause', foreign_key: :support_cause_id

end