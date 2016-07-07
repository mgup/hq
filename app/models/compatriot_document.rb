# Документы, подтверждающие принадлежность к соотечественникам
class CompatriotDocument < ActiveRecord::Base
  belongs_to :entrant, class_name: 'Entrance::Entrant', foreign_key: :entrance_entrant_id
end
