class RenameUseSubjectIdInEntranceMinScore < ActiveRecord::Migration
  def change
    rename_column :entrance_min_scores, :use_subject_id, :entrance_exam_id
  end
end
