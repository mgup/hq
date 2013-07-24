class Document::DocumentStudent < ActiveRecord::Base
  self.table_name = 'document_student'

  alias_attribute :doc,        :document_student_document
  alias_attribute :student,    :student_id

  belongs_to :document, class_name: Document::Doc, primary_key: :document_id, foreign_key: :document_student_document
  belongs_to :student, primary_key: :student_id, foreign_key: :student_id
end