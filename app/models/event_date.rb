class EventDate < ActiveRecord::Base
  self.table_name = 'event_date'

  belongs_to :event, class_name: Event
  has_many :visitor_event_dates
  has_many :users, through: :visitor_event_dates, source: :user,
          conditions: "visitor_event_date.visitor_type = 'User'"
  has_many :students, through: :visitor_event_dates, source: :student,
           conditions: "visitor_event_date.visitor_type = 'Student'"

#  scope :not_full, -> { where("max_visitors > (SELECT COUNT(*) from `event_date`
#  JOIN `visitor_event_date` on `event_date`.id = `visitor_event_date`.event_date_id
#WHERE `event_date`.id)") }
  def visitors
    self.users + self.students
  end

  def date_with_time
    "#{I18n.l date, format: :long} (#{I18n.l time_start, format: '%H:%M'}#{ ' - ' + (I18n.l time_end, format: '%H:%M') if time_end})"
  end
end