class Entrance::Event < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  has_many :event_entrants, class_name: Entrance::EventEntrant, foreign_key: :entrance_event_id
  has_many :entrants, class_name: Entrance::Entrant, through: :event_entrants
  belongs_to :campaign, class_name: Entrance::Campaign

  scope :without, -> ids { where('id NOT IN (?)', ids) }
  scope :without_classroom, -> { where('with_classroom IS NULL OR with_classroom = FALSE') }

  def name_with_date
    "#{name}, #{ (with_time ? (I18n.l date) : (I18n.l date, format: '%d %b %Y')) if date}"
  end

end