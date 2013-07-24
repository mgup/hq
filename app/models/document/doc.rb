class Document::Doc < ActiveRecord::Base
  TYPE_CONTRACT = 5

  self.table_name = 'document'

  alias_attribute :id,       :document_id
  alias_attribute :type,     :document_type
  alias_attribute :number,   :document_number
  alias_attribute :date,     :document_create_date

  has_many :document_students, class_name: Document::DocumentStudent, primary_key: :document_id,
           foreign_key: :document_student_document
  has_many :students, through: :document_students

  has_many :metas, class_name: Document::Meta, primary_key: :document_id, foreign_key: :document_meta_document

  # Получение имени плательщика по договору.
  def payer
    metas.where(document_meta_pattern: 'Плательщик').first.text if TYPE_CONTRACT == type
  end
end