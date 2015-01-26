class RenameAchievementReportValid < ActiveRecord::Migration
  def change
    rename_column :achievement_reports, :valid, :relevant
  end
end
