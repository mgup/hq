class CreateInstitutionAchievement < ActiveRecord::Migration
  def change
    create_table :institution_achievements do |t|
      t.string :name
    end
  end
end
