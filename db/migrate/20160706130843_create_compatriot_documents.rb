class CreateCompatriotDocuments < ActiveRecord::Migration
  def change
    create_table :compatriot_documents do |t|
      t.string     :series
      t.string     :number
      t.date       :date
      t.string     :organization
      t.text       :additional_info
      t.string     :type_name
      t.integer    :compatriot_category_id
      t.belongs_to :entrance_entrant
    end
  end
end
