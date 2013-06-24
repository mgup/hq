class CreateSessionMark < ActiveRecord::Migration
  def change
     add_index :session_marks, :user_id
  end
end
