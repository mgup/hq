class GraduateStudent < ActiveRecord::Base
  belongs_to :graduate
  belongs_to :student

  has_many :graduate_marks, -> { includes(:graduate_subject).order('graduate_subjects.kind') }, dependent: :destroy
  accepts_nested_attributes_for :graduate_marks
end
