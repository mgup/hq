class CreateEducationLevels < ActiveRecord::Migration
  def change
    create_table :education_levels do |t|
      t.integer :course, null: false, default: 1
      t.references :education_type, null: false, default: 2

      t.timestamps
    end
  end
end
