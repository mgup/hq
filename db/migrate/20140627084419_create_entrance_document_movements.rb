class CreateEntranceDocumentMovements < ActiveRecord::Migration
  def change
    create_table :entrance_document_movements do |t|
      t.boolean :moved
      t.boolean :original
      t.integer :from_application_id
      t.integer :to_application_id

      t.timestamps
    end
  end
end
