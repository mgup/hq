class AddTimestampsToCompetitiveGroup < ActiveRecord::Migration
  def change
    change_table :competitive_groups do |t|
      t.timestamps
    end
  end
end
