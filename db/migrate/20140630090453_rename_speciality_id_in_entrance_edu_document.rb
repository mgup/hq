class RenameSpecialityIdInEntranceEduDocument < ActiveRecord::Migration
  def change
    rename_column :entrance_edu_documents, :speciality_id, :direction_id
    add_column :entrance_edu_documents, :qualification, :string
  end
end
