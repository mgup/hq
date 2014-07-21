class EducationForm < ActiveRecord::Base
  has_and_belongs_to_many :entrance_campaigns, class_name: 'Entrance::Campaign'

  # Очная, очно-заочная, заочная.
  default_scope do
    order('id = 10, id = 12')
  end
end
