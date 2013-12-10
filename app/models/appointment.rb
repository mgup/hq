class Appointment < ActiveRecord::Base
  default_scope do
    order(:title)
  end

  has_many :positions
end
