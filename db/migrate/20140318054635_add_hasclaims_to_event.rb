class AddHasclaimsToEvent < ActiveRecord::Migration
  def change
    add_column :event, :hasclaims, :boolean, default: false
  end
end
