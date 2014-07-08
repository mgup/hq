class AddFormToEntranceExam < ActiveRecord::Migration
  def change
    change_table :entrance_exams do |t|
      t.integer :form, default: 1, null: false
    end
  end
end
