class AddEntrantIdToStudentGroup < ActiveRecord::Migration
  def change
    change_table :student_group do |t|
      t.belongs_to :entrant
    end
  end
end
