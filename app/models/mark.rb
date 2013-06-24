class Mark < ActiveRecord::Base
  self.table_name = 'session_marks'

  belongs_to :session, primary_key: :session_id, foreign_key: :session_id
  belongs_to :student, primary_key: :student_id, foreign_key: :student_id
  belongs_to :user, primary_key: :user_id, foreign_key: :user_id

end