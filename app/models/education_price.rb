class EducationPrice < ActiveRecord::Base
  belongs_to :direction
  belongs_to :education_form

  scope :for_year, -> (year) { where(entrance_year: year) }

  scope :for_form, -> (form_id) { where(education_form_id: form_id) }

  scope :for_direction, -> (direction_id) { where(direction_id: direction_id) }
end
