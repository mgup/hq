class Achievement < ActiveRecord::Base
  belongs_to :achievement_period
  belongs_to :user
  belongs_to :activity

  scope :by, -> (user = current_user) { where(user_id: user.id) }
end