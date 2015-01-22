class AddDiplomaToGraduateStudent < ActiveRecord::Migration
  def change
    add_column :graduate_students, :diploma, :string
  end
end
