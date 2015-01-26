class DropGraduateTables < ActiveRecord::Migration
  def change
    drop_table :graduates
    drop_table :graduate_marks
    drop_table :graduate_students
    drop_table :graduate_subjects
  end
end
