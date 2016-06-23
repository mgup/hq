class Region < ActiveRecord::Base
  has_many :entrants, class_name: 'Entrance::Entrant'
end
