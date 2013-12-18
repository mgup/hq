class VisitorEventDate < ActiveRecord::Base
  self.table_name = 'visitor_event_date'

  validate :visitors_count

  belongs_to :date, class_name: EventDate, primary_key: :id, foreign_key: :event_date_id
  belongs_to :visitor, polymorphic: true
  belongs_to :user,  class_name: User, foreign_key: :visitor_id
  belongs_to :student, class_name: Student, foreign_key: :visitor_id

  scope :from_visitor, -> visitor { where visitor: visitor}

  def visitors_count
      return if date.visitors.blank?
      errors.add(:'visitors', 'Все места на данное время забронированы') if date.visitors.size > date.max_visitors
  end
end