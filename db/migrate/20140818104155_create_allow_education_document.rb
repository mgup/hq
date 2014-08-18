class CreateAllowEducationDocument < ActiveRecord::Migration
  def change
    create_table :allow_education_documents do |t|
      t.boolean    :original, default: true
      t.string     :number
      t.date       :date
      t.string     :organization
      t.belongs_to :entrance_benefit
    end
  end
end
