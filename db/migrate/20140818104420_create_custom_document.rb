class CreateCustomDocument < ActiveRecord::Migration
  def change
    create_table :custom_documents do |t|
      t.boolean    :original, default: true
      t.string     :series
      t.string     :number
      t.date       :date
      t.string     :organization
      t.text       :additional_info
      t.string     :type_name
      t.belongs_to :entrance_benefit
    end
  end
end
