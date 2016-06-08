class CreateStudyVkrMaterials < ActiveRecord::Migration
  def change
    create_table :study_vkr_materials do |t|
      t.references :vkr, null: false, index: true

      t.timestamps null: false
    end

    add_attachment :study_vkr_materials, :data
  end
end
