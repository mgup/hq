class Social::Document < ActiveRecord::Base
  self.table_name = 'social_documents'

  belongs_to :person, class_name: 'Person', foreign_key: :student_id, primary_key: :student_id
  belongs_to :type, class_name: 'Social::DocumentType', foreign_key: :social_document_type_id

end