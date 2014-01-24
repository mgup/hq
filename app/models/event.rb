class Event < ActiveRecord::Base
  self.table_name = 'event'
  validates :name, presence: true
  validates :description, presence: true

  has_many :dates, class_name: EventDate
  has_many :users, through: :dates
  belongs_to :event_category, class_name: EventCategory
  scope :from_name, -> name { where('name LIKE :prefix', prefix: "%#{name}%")}
  scope :no_booking, -> {where(booking: false)}
end