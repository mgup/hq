class Appointment < ActiveRecord::Base
  default_scope do
    order(:title)
  end
end
