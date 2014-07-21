class Entrance::Log < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :user
  belongs_to :entrant, class_name: 'Entrance::Entrant'

  default_scope do
    order(:created_at, :id)
  end

  scope :for_entrant, -> (entrant) do
    where(entrant_id: entrant.id)
  end
end
