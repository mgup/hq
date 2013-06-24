class Session::Mark < ActiveRecord::Base
  self.table_name = 'session_marks'

  belongs_to :session
  belongs_to :student
  belongs_to :user
end