class ChangeMarkRetakeDefaultValue < ActiveRecord::Migration
  def change
    change_column :study_marks, :retake, :integer, null: false, default: 0
  end
end
