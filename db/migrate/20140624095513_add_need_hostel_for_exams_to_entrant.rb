class AddNeedHostelForExamsToEntrant < ActiveRecord::Migration
  def change
    change_table :entrance_entrants do |t|
      t.boolean :need_hostel_for_exams, default: false, null: false
    end
  end
end
