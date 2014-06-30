class AddOriginalChangedToDocumentMovement < ActiveRecord::Migration
  def change
    change_table :entrance_document_movements do |t|
      t.boolean :original_changed, default: false
    end
  end
end
