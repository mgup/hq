class Event < ActiveRecord::Base
  self.table_name = 'event'
  validates :name, presence: true
  validates :description, presence: true

  has_many :dates, class_name: EventDate
  belongs_to :event_category, class_name: EventCategory
  scope :from_name, -> name { where('name LIKE :prefix', prefix: "%#{name}%")}
  scope :no_booking, -> {where(booking: false)}
end