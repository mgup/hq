class CreateAchievementReport < ActiveRecord::Migration
  def change
    create_table :achievement_reports do |t|
      t.references :achievement_period, index: true
      t.references :user, index: true

      t.boolean  :valid, default: true

      t.timestamps
    end
  end
end
