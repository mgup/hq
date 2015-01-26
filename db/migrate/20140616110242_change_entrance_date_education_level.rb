class ChangeEntranceDateEducationLevel < ActiveRecord::Migration
  def change
    rename_column :entrance_dates, :education_level_id, :education_type_id
  end
end
