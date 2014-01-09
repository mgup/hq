class Achievement < ActiveRecord::Base
  STATUS_NEW      = 1
  STATUS_ACCEPTED = 2
  STATUS_REFUSED  = 3

  belongs_to :period, class_name: 'AchievementPeriod', foreign_key: 'achievement_period_id'
  belongs_to :user
  belongs_to :activity

  default_scope do
    joins(:activity)
    .order('activities.activity_group_id, activities.id')
  end

  scope :by, -> (user = current_user) { where(user_id: user.id) }

  scope :validatable_by, -> (user = current_user) {
    user_roles = user.roles.map(&:id)

    joins(:activity).where('activities.role_id IN (?)', user_roles)
  }

  def new?
    STATUS_NEW == status
  end

  def accepted?
    STATUS_ACCEPTED == status
  end

  def refused?
    STATUS_REFUSED == status
  end
end