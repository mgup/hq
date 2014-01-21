class EventCategory < ActiveRecord::Base
  self.table_name = 'event_category'
  validates_presence_of :name

  has_many :events
end