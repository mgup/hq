class GraduateChoiceStudent < ActiveRecord::Base
  self.table_name = 'graduate_choice_subject_student'

  belongs_to :choice, class_name: GraduateChoice, foreign_key: :graduate_choice_subject_id
  belongs_to :student, class_name: GraduateStudent, foreign_key: :graduate_student_id

  scope :from_student, -> student { where(graduate_student_id: student) }
end