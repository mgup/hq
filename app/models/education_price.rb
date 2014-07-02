class EducationPrice < ActiveRecord::Base
  belongs_to :direction
  belongs_to :education_form

  scope :for_year, -> (year) { where(entrance_year: year) }
end
