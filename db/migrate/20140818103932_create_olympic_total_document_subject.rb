class CreateOlympicTotalDocumentSubject < ActiveRecord::Migration
  def change
    create_table :olympic_total_document_subjects do |t|
      t.belongs_to :subject
      t.belongs_to :olympic_total_document
    end
  end
end
