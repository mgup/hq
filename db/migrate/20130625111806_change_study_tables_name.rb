class ChangeStudyTablesName < ActiveRecord::Migration
  def change
    rename_table :sessions, :study_subjects
    rename_table :session_marks, :study_marks
  end
end
