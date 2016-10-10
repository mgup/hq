class Study::ExamUser < ActiveRecord::Base
  self.table_name = 'exam_users'

  belongs_to :repeat, class_name: Study::Repeat, primary_key: :exam_id, foreign_key: :exam_id
  belongs_to :user, class_name: User, primary_key: :user_id, foreign_key: :user_id

end
