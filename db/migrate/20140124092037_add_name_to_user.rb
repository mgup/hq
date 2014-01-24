class AddNameToUser < ActiveRecord::Migration
  def change
    add_column :user, :last_name_hint, :string
    add_column :user, :first_name_hint, :string
    add_column :user, :patronym_hint, :string
  end
end
