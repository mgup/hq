class CreateSocialDocumentType < ActiveRecord::Migration
  def change
    create_table :social_document_types do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
