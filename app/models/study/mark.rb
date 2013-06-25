class Study::Mark < ActiveRecord::Base
  self.table_name = 'study_marks'

  belongs_to :subject, :class_name => Study::Subject
  belongs_to :student
  belongs_to :user
end