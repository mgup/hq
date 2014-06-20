class AddCampaignToApplication < ActiveRecord::Migration
  def change
    add_column :entrance_applications, :campaign_id, :integer, null: false
  end
end
