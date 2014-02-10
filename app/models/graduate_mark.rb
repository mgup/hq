class GraduateMark < ActiveRecord::Base
  belongs_to :graduate_student
  belongs_to :graduate_subject
end
