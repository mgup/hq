class AddRetakeToSessionMark < ActiveRecord::Migration
  def change
    add_column :session_marks, :retake, :integer
  end
end
