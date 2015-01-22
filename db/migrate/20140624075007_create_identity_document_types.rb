class CreateIdentityDocumentTypes < ActiveRecord::Migration
  def change
    create_table :identity_document_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
