class AddAcceptedToSupport < ActiveRecord::Migration
  def change
    add_column :support, :accepted, :boolean, default: false
  end
end
