class Role < ActiveRecord::Base
  self.table_name = 'acl_role'

  ROLE_CURATOR = 28

  alias_attribute :id,    :acl_role_id
  alias_attribute :name,  :acl_role_name
  alias_attribute :title, :acl_role_description

  default_scope do
    where(active: true)
    .order(:acl_role_description)
  end

  scope :ordered, -> { order(:acl_role_description) }

  def active?
    active
  end
end