class CreateGraduateSubjects < ActiveRecord::Migration
  def change
    create_table :graduate_subjects do |t|
      t.references :graduate

      t.string :name
      t.integer :type
      t.integer :hours
      t.integer :zet

      t.timestamps
    end
  end
end
