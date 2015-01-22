class Document::DocumentPerson < ActiveRecord::Base
  self.table_name = 'document_student'

  belongs_to :document, class_name: Document::Doc, primary_key: :document_id, foreign_key: :document_student_document
  belongs_to :person, primary_key: :student_id, foreign_key: :student_id
end