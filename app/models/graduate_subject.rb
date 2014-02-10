class GraduateSubject < ActiveRecord::Base
  TYPE_SUBJECT  = 1
  TYPE_PAPER    = 2

  belongs_to :graduate

  has_many :graduate_students
  has_many :graduate_marks
end
