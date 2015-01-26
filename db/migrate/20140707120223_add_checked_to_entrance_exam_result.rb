class AddCheckedToEntranceExamResult < ActiveRecord::Migration
  def change
    change_table :entrance_exam_results do |t|
      t.boolean :checked, default: false
      t.datetime :checked_at
    end
  end
end
