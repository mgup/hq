class EventDateClaim < ActiveRecord::Base
  STATUS_NOT_ACCEPTED = 1
  STATUS_ACCEPTED = 2
  self.table_name = 'event_date_claim'

  belongs_to :group
  belongs_to :event

  scope :accepted, -> {where(status: STATUS_ACCEPTED)}

  def accepted?
    STATUS_ACCEPTED == status
  end
end