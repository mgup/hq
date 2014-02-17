class Event < ActiveRecord::Base
  self.table_name = 'event'
  validates :name, presence: true
  validates :description, presence: true
  validates_associated :dates

  has_many :dates, class_name: EventDate
  accepts_nested_attributes_for :dates, allow_destroy: true
  has_many :users, through: :dates
  belongs_to :category, class_name: EventCategory
  scope :from_name, -> name { where('name LIKE :prefix', prefix: "%#{name}%")}
  scope :no_booking, -> {where(booking: false)}
end