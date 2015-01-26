class CreateSupportCauseDocumentType < ActiveRecord::Migration
  def change
    create_table :support_cause_document_types do |t|
      t.belongs_to :support_cause
      t.belongs_to :social_document_type
    end
  end
end
