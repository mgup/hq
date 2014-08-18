class CreateMedicalDisabilityDocument < ActiveRecord::Migration
  def change
    create_table :medical_disability_documents do |t|
      t.boolean    :original, default: true
      t.string     :series
      t.string     :number
      t.date       :date
      t.string     :organization
      t.integer    :disability_type_id
      t.integer    :kind
      t.belongs_to :entrance_benefit
    end
  end
end
