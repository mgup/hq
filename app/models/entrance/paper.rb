class Entrance::Paper < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :entrant, class_name: Entrance::Entrant, foreign_key: :entrance_entrant_id

end