class AddStudentGroupIdToEntrant < ActiveRecord::Migration
  def change
    change_table :entrance_entrants do |t|
      t.belongs_to :student
    end
  end
end
