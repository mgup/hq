class Role < ActiveRecord::Base
  self.table_name = 'acl_role'

  ROLE_CURATOR = 34
  ROLE_LECTURER = 8
  ROLE_SUBDEPARTMENT = 7

  alias_attribute :id,    :acl_role_id
  alias_attribute :name,  :acl_role_name
  alias_attribute :title, :acl_role_description

  default_scope do
    where(active: true)
    .order(:acl_role_description)
  end

  scope :ordered, -> { order(:acl_role_description) }
  scope :by_name, -> name {where(acl_role_name: name)}

  def active?
    active
  end
end