class GraduateStudent < ActiveRecord::Base
  belongs_to :graduate
  belongs_to :student

  has_many :graduate_marks
end
