class RenameStudyMarksColumn < ActiveRecord::Migration
  def change
    rename_column :study_marks, :session_id, :subject_id
  end
end
