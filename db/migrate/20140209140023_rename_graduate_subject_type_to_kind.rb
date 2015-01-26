class RenameGraduateSubjectTypeToKind < ActiveRecord::Migration
  def change
    rename_column :graduate_subjects, :type, :kind
  end
end
