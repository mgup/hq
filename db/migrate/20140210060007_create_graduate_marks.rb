class CreateGraduateMarks < ActiveRecord::Migration
  def change
    create_table :graduate_marks do |t|
      t.references :graduate_student
      t.references :graduate_subject
      t.string :mark

      t.timestamps
    end
  end
end
