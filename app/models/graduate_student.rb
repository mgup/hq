class GraduateStudent < ActiveRecord::Base
  belongs_to :graduate
  belongs_to :student

  has_many :graduate_marks, -> { includes(:graduate_subject).order('graduate_subjects.kind') }, dependent: :destroy
  accepts_nested_attributes_for :graduate_marks

  has_many :choice_students, class_name: GraduateChoiceStudent, foreign_key: :graduate_student_id, dependent: :destroy
  accepts_nested_attributes_for :choice_students, allow_destroy: true, reject_if: proc { |attrs| attrs[:graduate_choice_subject_id].blank? }
  has_many :choices, class_name: GraduateChoice, through: :choice_students
end
