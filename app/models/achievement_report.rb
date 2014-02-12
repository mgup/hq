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

  def accepted?
    achievement_period.achievements.by(user).inject(true) do |res, a|
      res = res && false unless a.accepted?

      res
    end
  end

  def accepted_or_refused?
    achievement_period.achievements.by(user).inject(true) do |res, a|
      res = res && false unless a.accepted? || a.accepted_final? || a.refused?

      res
    end
  end

  def accepted_final?
    achievement_period.achievements.by(user).inject(true) do |res, a|
      res = res && false unless a.accepted_final? && a.cost?

      res
    end
  end
end