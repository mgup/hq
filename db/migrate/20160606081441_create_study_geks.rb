class CreateStudyGeks < ActiveRecord::Migration
  def change
    create_table :study_geks do |t|
      t.references :position, null: false
      t.integer :study_year, null: false
      t.references :group, null: false

      t.timestamps null: false
    end
  end
end
