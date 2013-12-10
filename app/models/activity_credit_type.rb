class ActivityCreditType < ActiveRecord::Base
  FLEXIBLE = 3
  DYNAMIC  = 4

  validates_presence_of :name

  has_many :activities
end