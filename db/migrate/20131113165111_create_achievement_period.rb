class CreateAchievementPeriod < ActiveRecord::Migration
  def change
    create_table :achievement_periods do |t|
      t.integer :year, null: false
      t.integer :semester, null: false
      t.boolean :active, default: false

      t.timestamps
    end

    remove_column :achievements, :year
    remove_column :achievements, :semester

    change_table :achievements do |t|
      t.references :achievement_periods, index: true
    end
  end
end
