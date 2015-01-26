class AddCampaignReferenceToEvent < ActiveRecord::Migration
  def change
    change_table :entrance_events do |t|
      t.references :campaign, null: false
    end
  end
end
