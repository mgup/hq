class EventCategory < ActiveRecord::Base
  self.table_name = 'event_category'
  MEDICAL_EXAMINATION_CATEGORY = 1
  SOCIAL_EVENTS_CATEGORY = 2

  validates_presence_of :name

  has_many :events
end