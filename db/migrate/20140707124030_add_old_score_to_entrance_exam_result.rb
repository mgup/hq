class AddOldScoreToEntranceExamResult < ActiveRecord::Migration
  def change
    change_table :entrance_exam_results do |t|
      t.integer :old_score
    end
  end
end
