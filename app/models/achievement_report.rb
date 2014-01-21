class AchievementReport < ActiveRecord::Base
  belongs_to :achievement_period
  belongs_to :user

  scope :by_user, -> (user) {
    where(user_id: user.id)
  }

  scope :only_relevant, -> { where(relevant: true).order('id DESC') }

  def relevant?
    relevant
  end
end