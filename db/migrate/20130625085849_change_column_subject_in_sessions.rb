class ChangeColumnSubjectInSessions < ActiveRecord::Migration
  def change
     rename_column :sessions, :subject, :title
  end
end
