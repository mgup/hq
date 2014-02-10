class GraduateSubject < ActiveRecord::Base
  TYPE_SUBJECT  = 1
  TYPE_PAPER    = 2

  belongs_to :graduate
end
