class CreateIdentityDocument < ActiveRecord::Migration
  def change
    create_table :identity_documents do |t|
      t.boolean    :original
      t.date       :original_date
      t.string     :series
      t.string     :number
      t.string     :subvision_code
      t.date       :date
      t.string     :organization
      t.integer    :identity_document_type_id
      t.integer    :nationality_type_id
      t.date       :birthday
      t.string     :birthplace
      t.boolean    :main

      t.belongs_to :entrance_entrant
    end
  end
end
