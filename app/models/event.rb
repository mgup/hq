class Event < ActiveRecord::Base
  STATUS_PUBLICATION = 1
  STATUS_DRAFT = 2
  STATUS_CLOSED = 3
  self.table_name = 'event'
  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates_associated :dates

  has_many :dates, class_name: EventDate
  has_many :claims, class_name: EventDateClaim
  accepts_nested_attributes_for :dates, allow_destroy: true
  has_many :users, through: :dates
  belongs_to :category, class_name: EventCategory
  scope :from_name, -> name { where('name LIKE :prefix', prefix: "%#{name}%")}
  scope :no_booking, -> {where(booking: false)}
  scope :publications, -> {where(status: STATUS_PUBLICATION, event_category_id: EventCategory::SOCIAL_EVENTS_CATEGORY)}
  scope :past, -> {where("event_date.date < '#{Date.today.strftime('%Y-%m-%d')}'").includes(:dates).references(:dates)}
  scope :future, -> {where("event_date.date >= '#{Date.today.strftime('%Y-%m-%d')}'").includes(:dates).references(:dates)}
  scope :without_date, -> {where("event.id NOT IN (SELECT DISTINCT event.id FROM event
                                JOIN event_date ON event.id = event_date.event_id)")}

  def draft?
    STATUS_DRAFT == status
  end

  def publication?
    STATUS_PUBLICATION == status
  end

  def closed?
    STATUS_CLOSED == status
  end

end