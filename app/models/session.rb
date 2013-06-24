class Session < ActiveRecord::Base
  self.table_name = 'sessions'

  belongs_to :group, primary_key: :group_id, foreign_key: :group_id
  belongs_to :user, primary_key: :user_id, foreign_key: :user_id

  has_many :session_marks, foreign_key: :session_id
end