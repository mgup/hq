class AddProfileIdToOlympicDocuments < ActiveRecord::Migration
  def change
    add_column :olympic_documents, :profile_id, :integer
    add_column :olympic_documents, :class_number, :string
  end
end
