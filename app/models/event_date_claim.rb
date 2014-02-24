class EventDateClaim < ActiveRecord::Base
  self.table_name = 'event_date_claim'

  belongs_to :group
  belongs_to :event
end