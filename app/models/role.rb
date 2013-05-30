class Role < ActiveRecord::Base
  self.table_name = 'acl_role'

  alias_attribute :id,          :acl_role_id
  alias_attribute :name,        :acl_role_name
  alias_attribute :description, :acl_role_description
end