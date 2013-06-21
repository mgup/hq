class ChangeColumnTypeInSessions < ActiveRecord::Migration
  def change
    rename_column :sessions, :type, :kind
    change_column :sessions, :kind, :integer
  end
end
