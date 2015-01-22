class CreateEntranceBenefits < ActiveRecord::Migration
  def change
    create_table :entrance_benefits do |t|
      t.belongs_to :application
      t.belongs_to :benefit_kind
      t.belongs_to :document_type
      t.string :temp_text

      t.timestamps
    end
  end
end
