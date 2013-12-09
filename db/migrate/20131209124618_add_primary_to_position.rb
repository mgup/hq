class AddPrimaryToPosition < ActiveRecord::Migration
  def change
    add_column :acl_position, :acl_position_primary, :boolean, default: false
  end
end
