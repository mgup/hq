class ActivityCreditType < ActiveRecord::Base
  FIXED    = 1
  NUMERIC  = 2
  FLEXIBLE = 3
  DYNAMIC  = 4

  validates_presence_of :name

  has_many :activities
end