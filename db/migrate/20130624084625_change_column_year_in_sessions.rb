class ChangeColumnYearInSessions < ActiveRecord::Migration
  def change
    change_column :sessions, :year, :integer
  end
end
