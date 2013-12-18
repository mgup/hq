class Event < ActiveRecord::Base
  self.table_name = 'event'

  has_many :dates, class_name: EventDate
end