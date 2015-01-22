class CreateAchievement < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer :year, null: false
      t.integer :semester, null: false
      t.text :description

      t.references :user, index: true
      t.references :activity, index: true

      t.timestamps
    end
  end
end
