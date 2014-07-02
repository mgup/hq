class EducationPrice < ActiveRecord::Base
  belongs_to :direction
  belongs_to :education_form
end
