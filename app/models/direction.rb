class Direction < ActiveRecord::Base
  belongs_to :department

  has_many :competitive_group_items, class_name: 'Entrance::CompetitiveGroupItem'
  has_many :min_scores, class_name: 'Entrance::MinScore'

  scope :for_campaign, -> (campaign) do
    joins(competitive_group_items: :competitive_group).
      where('competitive_groups.campaign_id = ?', campaign.id).
      group(:new_code).order(:name, :new_code)
  end

  scope :with_new_code, -> { where('new_code IS NOT NULL AND new_code != ""') }
  scope :for_aspirants, -> { where('new_code LIKE "%.05.%"') }

  def description
    "#{new_code} #{name}"
  end
end