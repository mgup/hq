class Entrance::UseCheck < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  has_many :results, class_name: Entrance::UseCheckResult, foreign_key: :use_check_id
  belongs_to :entrant, class_name: Entrance::Entrant

  scope :today, -> { where(date: Date.today.beginning_of_day..Date.today.end_of_day) }

end