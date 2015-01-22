class AddStatusFieldToEventDateClaim < ActiveRecord::Migration
  def change
    add_column :event_date_claim, :status, :integer
  end
end
