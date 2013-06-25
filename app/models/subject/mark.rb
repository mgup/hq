class Subject::Mark < ActiveRecord::Base
  self.table_name = 'session_marks'

  belongs_to :subject, primary_key: :subject_id, foreign_key: :session_id
  belongs_to :student
  belongs_to :user
end