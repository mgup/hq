class Document::Meta < ActiveRecord::Base
  self.table_name = 'document_meta'

  alias_attribute :id,       :document_meta_id
  alias_attribute :pattern,     :document_meta_pattern
  alias_attribute :text,   :document_meta_text

  belongs_to :doc, class_name: Document::Doc, primary_key: :document_id, foreign_key: :document_meta_document


end