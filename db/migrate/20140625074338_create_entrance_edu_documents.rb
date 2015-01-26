class CreateEntranceEduDocuments < ActiveRecord::Migration
  def change
    create_table :entrance_edu_documents do |t|
      t.belongs_to :document_type
      t.string :series
      t.string :number
      t.date :date
      t.string :organization
      t.integer :graduation_year
      t.float :gpa
      t.string :registration_number
      t.belongs_to :qualification_type
      t.belongs_to :speciality
      t.belongs_to :specialization
      t.belongs_to :profession
      t.string :document_type_name_text

      t.timestamps
    end
  end
end
