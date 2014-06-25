class CreateEntranceDocumentTypes < ActiveRecord::Migration
  def change
    create_table :entrance_document_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
