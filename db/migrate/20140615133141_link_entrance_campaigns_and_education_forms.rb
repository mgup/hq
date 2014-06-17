class LinkEntranceCampaignsAndEducationForms < ActiveRecord::Migration
  def change
    create_table :education_forms_entrance_campaigns, id: false do |t|
      t.belongs_to :campaign
      t.belongs_to :education_form
    end
  end
end
