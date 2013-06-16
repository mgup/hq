class Teacher < ActiveRecord::Base
  self.table_name = 'teacher'

  alias_attribute :id,  :teacher_id

  belongs_to :subdepartment, class_name: Department, primary_key: :department_id, foreign_key: :teacher_subdepartment

  has_many :subject_teachers
  has_many :subjects, :through => :subject_teachers

end