class ActivityType < ActiveRecord::Base
  TYPE_BOOLEAN = 2

  validates_presence_of :name

  has_many :activities
end