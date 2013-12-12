class Document::DocumentStudent < ActiveRecord::Base
  self.table_name = 'document_student_group'

  belongs_to :document, class_name: Document::Doc, primary_key: :document_id, foreign_key: :document_student_group_document
  belongs_to :student, primary_key: :student_group_id, foreign_key: :student_group_id
end