class ChangeNullValuesInSessions < ActiveRecord::Migration
  def change
    change_table :sessions do |t|
      t.change :year, :integer, null: false
      t.change :semester, :integer, null: false
      t.change :group_id, :integer, null: false
      t.change :subject, :string, null: false
      t.change :kind, :integer, null: false
      t.change :user_id, :integer, null: false
    end
  end
end
