class EventDate < ActiveRecord::Base
  self.table_name = 'event_date'

  validates :date, presence: true
  validates :time_start, presence: true

  belongs_to :event, class_name: Event
  has_many :visitor_event_dates
  has_many :users, -> {where("visitor_event_date.visitor_type = 'User'")},
                      through: :visitor_event_dates, source: :user

  has_many :students, -> {where("visitor_event_date.visitor_type = 'Student'")},
                          through: :visitor_event_dates, source: :student

  scope :not_full, -> { where('max_visitors > (SELECT COUNT(visitor_event_date.id) from `event_date` as `ed`
  JOIN `visitor_event_date` on `ed`.id = `visitor_event_date`.event_date_id
  WHERE `ed`.id = `event_date`.id)') }
  scope :from_date, -> somedate { where(date: Date.parse(somedate))}

  def visitors
    self.users + self.students
  end

  def date_with_time
    "#{I18n.l date, format: :long} (#{I18n.l time_start, format: '%H:%M'}#{ ' - ' + (I18n.l time_end, format: '%H:%M') if time_end})"
  end

  def self.valid_max_visitors?(visitors, value)
    date = self.new('max_visitors' => value)
    return date.max_visitors >= visitors
  end

end