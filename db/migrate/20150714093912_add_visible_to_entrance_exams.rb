class AddVisibleToEntranceExams < ActiveRecord::Migration
  def change
    change_table :entrance_exams do |t|
      t.boolean :visible, default: false
    end
  end
end
