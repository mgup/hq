class Activity < ActiveRecord::Base
  # Идентификатор показателя в базе, отвечающего за преподавательскую нагрузку.
  TEACHING_LOAD = 46

  validates_presence_of :activity_group_id, :activity_type_id, :name

  belongs_to :activity_group
  belongs_to :group, class_name: 'ActivityGroup', foreign_key: :activity_group_id

  belongs_to :activity_type

  belongs_to :activity_credit_type

  belongs_to :validator, class_name: 'Role',
             foreign_key: :acl_role_id, primary_key: :role_id

  has_many :achievements

  scope :without_teaching_load, -> { where('activities.id != ?', TEACHING_LOAD) }

  def unique?
    unique
  end

  # Фиксированный максимальный балл.
  def fixed_credits?
    ActivityCreditType::FIXED == activity_credit_type_id
  end

  # Количественный максимальный балл — зависит от величины значения value в достижении.
  def numeric_credits?
    ActivityCreditType::NUMERIC == activity_credit_type_id
  end

  def flexible_credits?
    ActivityCreditType::FLEXIBLE == activity_credit_type_id
  end

  def dynamic_credits?
    ActivityCreditType::DYNAMIC == activity_credit_type_id
  end

  def need_cost?
    activity_type.id != ActivityType::TYPE_BOOLEAN && (fixed_credits? || numeric_credits?)
  end
end