class CreateGraduateStudents < ActiveRecord::Migration
  def change
    create_table :graduate_students do |t|
      t.references :graduate
      t.references :student

      t.string :thesis
      t.integer :mark
      t.string :registration
      t.string :education

      t.timestamps
    end
  end
end
