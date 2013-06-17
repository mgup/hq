class SubjectTeacher < ActiveRecord::Base
self.table_name = 'subject_teacher'

belongs_to :user, primary_key: :user_id, foreign_key: :teacher_id
belongs_to :subject, primary_key: :subject_id, foreign_key: :subject_id

end