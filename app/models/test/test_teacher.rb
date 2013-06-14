class Teacher < ActiveRecord::Base
  self.table_name = 'teacher'

  alias_attribute :id,  :teacher_id

  belongs_to :user, class_name: User, primary_key: :user_id
  belongs_to :department, primary_key: :department_id, foreign_key: :teacher_department

  has_many :subject_teachers
  has_many :subjects, :through => :subject_teachers

end