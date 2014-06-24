class NationalityType < ActiveRecord::Base
  has_many :entrants, class_name: 'Entrance::Entrant'

  default_scope do
    order(:name)
  end
end
