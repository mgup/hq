class CreateSocialDocument < ActiveRecord::Migration
  def change
    create_table :social_documents do |t|
      t.belongs_to :student
      t.belongs_to :social_document_type
      t.string  :number
      t.string  :department
      t.date    :start_date
      t.date    :expire_date
      t.integer :status
      t.timestamps
    end
  end
end
