class AddEntrantIdToEduDocuments < ActiveRecord::Migration
  def change
    change_table :entrance_edu_documents do |t|
      t.belongs_to :entrant
    end
  end
end
