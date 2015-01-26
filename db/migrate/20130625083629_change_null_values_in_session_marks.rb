class ChangeNullValuesInSessionMarks < ActiveRecord::Migration
  def change
    change_table :session_marks do |t|
      t.change :student_id, :integer, null: false
      t.change :mark, :integer, null: false
      t.change :user_id, :integer, null: false
    end
  end
end
