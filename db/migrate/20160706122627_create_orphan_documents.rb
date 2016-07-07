class CreateOrphanDocuments < ActiveRecord::Migration
  def change
    create_table :orphan_documents do |t|
      t.string     :series
      t.string     :number
      t.date       :date
      t.string     :organization
      t.text       :additional_info
      t.string     :type_name
      t.integer    :orphan_category_id
      t.belongs_to :entrance_benefit
    end
  end
end
