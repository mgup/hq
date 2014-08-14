class RenameEducationLevelToEducationType < ActiveRecord::Migration
  def change
    rename_column :competitive_group_items, :education_level_id, :education_type_id
  end
end
