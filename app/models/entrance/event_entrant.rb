class Entrance::EventEntrant < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :event, class_name: Entrance::Event, foreign_key: :entrance_event_id
  belongs_to :entrant,  class_name: Entrance::Entrant, foreign_key: :entrance_entrant_id

  scope :from_event, -> event { where(entrance_event_id: event.id) }

end