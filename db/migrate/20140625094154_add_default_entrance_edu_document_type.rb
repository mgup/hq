class AddDefaultEntranceEduDocumentType < ActiveRecord::Migration
  def change
    change_column_default :entrance_edu_documents, :document_type_id, 3
    change_column_null :entrance_edu_documents, :document_type_id, false
  end
end
