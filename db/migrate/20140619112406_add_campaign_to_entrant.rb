class AddCampaignToEntrant < ActiveRecord::Migration
  def change
    add_column :entrance_entrants, :campaign_id, :integer, null: false
  end
end
