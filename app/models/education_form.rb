class EducationForm < ActiveRecord::Base
  has_and_belongs_to_many :entrance_campaigns, class_name: 'Entrance::Campaign'
end
