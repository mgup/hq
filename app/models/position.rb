class Position < ActiveRecord::Base
  self.table_name = 'acl_position'

  alias_attribute :id,          :acl_position_id
  alias_attribute :title,       :acl_position_title
  alias_attribute :dismission,  :acl_position_dismission
  alias_attribute :primary,     :acl_position_primary

  belongs_to :user,       primary_key: :user_id,       foreign_key: :acl_position_user
  belongs_to :role,       primary_key: :acl_role_id,   foreign_key: :acl_position_role
  belongs_to :department, primary_key: :department_id, foreign_key: :acl_position_department
  belongs_to :appointment

  #def self.find_or_create_by_position_id(position_id)
  #  obj = (self.find(position_id) || self.new)
  #  obj.save
  #end

  scope :from_role, -> role { joins(:role).where(acl_role: { acl_role_name: role })}

  def info
    "#{appointment.title}, #{department.abbreviation}" unless appointment.nil?
  end
end