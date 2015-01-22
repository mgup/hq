class Entrance::Classroom < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  has_many :event_entrants, class_name: Entrance::EventEntrant
  has_many :entrants, class_name: Entrance::Entrant, through: :event_entrants

end