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

  scope :not_refused, -> { where('status != ?', STATUS_REFUSED) }

  scope :validatable_by, -> (user = current_user) {
    user_roles = user.roles.map(&:id).map(&:to_i)

    joins(:activity).where('activities.role_id IN (?)', user_roles)
    .order('status ASC, user_id')
  }

  scope :for_subdepartment, -> (user = current_user) {
    dep_ids = user.positions.from_role(:subdepartment.to_s).map { |p| p.department.id }
    users = User.in_department(dep_ids).with_role(Role.select(:acl_role_id).where(acl_role_name: 'lecturer'))
    ids = users.map { |u| u.id }.push(user.id)

    where(user_id: ids).order('status ASC, user_id')
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