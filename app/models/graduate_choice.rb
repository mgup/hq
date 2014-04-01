class GraduateChoice < ActiveRecord::Base
  self.table_name = 'choice_subject'

  belongs_to :graduate_subject, foreign_key: :graduate_subjects_id
  has_many :choice_students, class_name: GraduateChoiceStudent, foreign_key: :graduate_choice_subject_id
  has_many :students, class_name: GraduateStudent, through: :graduate_subject_students
end