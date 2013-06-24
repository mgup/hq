class CreateSessionMark < ActiveRecord::Migration
  def change
    create_table 'session_marks' do |t|
      t.integer  'session_id'
      t.integer  'student_id'
      t.integer  'mark'
      t.integer  'user_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

     add_index :session_marks, :user_id
  end
end
