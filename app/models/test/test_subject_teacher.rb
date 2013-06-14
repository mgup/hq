class SubjectTeacher < ActiveRecord::Base
self.table_name = 'subject_teacher'

alias_attribute :teacher_id,  :teacher_id
alias_attribute :subject_id,  :subject_id

  belongs_to :teacher
  belongs_to :subject

end