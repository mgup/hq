class Achievement < ActiveRecord::Base
  STATUS_NEW      = 1
  STATUS_ACCEPTED = 2
  STATUS_REFUSED  = 3
  STATUS_ACCEPTED_FINAL = 4

  belongs_to :period, class_name: 'AchievementPeriod', foreign_key: 'achievement_period_id'
  belongs_to :user
  belongs_to :activity

  default_scope do
    joins(:activity)
    .order('activities.activity_group_id, activities.id')
  end

  scope :by, -> (user = current_user) { where(user_id: user.id) }

  scope :for, -> (period) { where(achievement_period_id: period.id) }

  scope :not_refused, -> { where('status != ?', STATUS_REFUSED) }

  scope :validatable_by, -> (user = current_user) {
    user_roles = user.roles.map(&:id).map(&:to_i)

    joins(:activity).where('activities.role_id IN (?)', user_roles)
    .order('status ASC, user_id')
  }

  scope :for_subdepartment, -> (user = current_user) {
    dep_ids = user.positions.from_role(:subdepartment.to_s).map { |p| p.department.id }
    users = User.in_department(dep_ids).with_role(Role.select(:acl_role_id).where(acl_role_name: 'lecturer'))
    ids = users.map(&:id).push(user.id)

    where(user_id: ids).where('status != 4').order('status ASC, user_id')
  }

  scope :in_selection, -> {
    joins(:period)
    .where(activity_id: 44).order('user_id, year')
  }

  scope :in_social, -> {
    joins(:period)
    .where(activity_id: 43).order('year, user_id')
  }

  scope :in_additional, -> (user, department, subdepartment = nil, year = 2013) {
    query = joins(:period).where(activity_id: 45).order('year, user_id')
              .where('achievement_periods.year = ?', year)

    if user.is?(:dean)
      query = query.joins(user: [{positions: :department}])
      query = query.joins('JOIN department AS pd ON department.department_parent = pd.department_id')
      query = query.where('pd.department_id = ?', department)
      query = query.where('acl_position_role IN (?)', [8, 7])

      if subdepartment
        query = query.where('department.department_id = ?', subdepartment)
      end
    end

    query
  }

  scope :in_department, -> (department, params = {}) {
    params[:only_accepted] ||= false
    params[:without_additional] ||= false

    query = joins(:period).order('year, user_id')
    query = query.joins(user: [{positions: :department}])
    query = query.joins('JOIN department AS pd ON department.department_parent = pd.department_id')

    query = query.where('pd.department_id = ?', department) unless 0 == department
    
    query = query.where('acl_position_role IN (?)', [8, 7])

    if params[:only_accepted]
      query = query.where('achievements.status IN (?)',
                          [Achievement::STATUS_ACCEPTED, Achievement::STATUS_ACCEPTED_FINAL])
    end

    if params[:without_additional]
      query = query.where('achievements.activity_id != 45')
    end

    query
  }

  def new?
    STATUS_NEW == status
  end

  def accepted?
    STATUS_ACCEPTED == status
  end

  def accepted_final?
    STATUS_ACCEPTED_FINAL == status
  end

  def refused?
    STATUS_REFUSED == status
  end

  def has_cost?
    if activity.need_cost?
      cost?
    else
      true
    end
  end

  def get_cost
    if activity.need_cost?
      cost
    else
      activity.credit
    end
  end

  #def self.combine_45_achievements
  #  [1,2].each do |period_id|
  #    user_ids = Achievement.unscoped.where(activity_id: 45)
  #      .where(achievement_period_id: period_id)
  #      .where('status NOT IN (?)', [3]).map(&:user_id).uniq
  #
  #    user_ids.each do |user_id|
  #      user = User.find(user_id)
  #
  #      iidizh = false
  #      user.departments_ids.each do |i|
  #        iidizh = true if [63,58,78,81,69,62,5].include?(i.to_i)
  #      end
  #
  #      unless iidizh
  #        achievements = Achievement.unscoped.where(user_id: user_id)
  #          .where(achievement_period_id: period_id)
  #          .where(activity_id: 45)
  #          .where('status NOT IN (?)', [3])
  #
  #        description = achievements.map(&:description).join("\n")
  #        cost = achievements.map(&:cost).map(&:to_i).sum
  #
  #        Achievement.create(user_id: user_id,
  #                           achievement_period_id: period_id,
  #                           description: description,
  #                           activity_id: 45,
  #                           cost: cost,
  #                           status: 1
  #        )
  #
  #        achievements.map(&:destroy)
  #      end
  #    end
  #  end
  #end
end
