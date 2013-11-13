class Achievement < ActiveRecord::Base
  belongs_to :achievement_period
  belongs_to :user
  belongs_to :activity
end