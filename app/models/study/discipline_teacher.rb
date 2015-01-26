class Study::DisciplineTeacher < ActiveRecord::Base
self.table_name = 'subject_teacher'

#alias_attribute :id,            :subject_teacher_id
alias_attribute :teacher,       :teacher_id
alias_attribute :discipline,    :subject_id

belongs_to :assistant_teacher, class_name: User, primary_key: :user_id, foreign_key: :teacher_id
belongs_to :discipline, class_name: Study::Discipline, primary_key: :subject_id, foreign_key: :subject_id

end