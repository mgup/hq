class CreateStudyVkrs < ActiveRecord::Migration
  def change
    create_table :study_vkrs do |t|
      t.references :student, null: false, index: true
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end
