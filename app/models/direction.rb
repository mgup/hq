class Direction < ActiveRecord::Base
  belongs_to :department

  has_many :competitive_group_items, class_name: 'Entrance::CompetitiveGroupItem'

  scope :for_campaign, -> (campaign) do
    joins(competitive_group_items: :competitive_group).
      where('competitive_groups.campaign_id = ?', campaign.id).
      group(:new_code).order(:name, :new_code)
  end

  def description
    "#{new_code} #{name}"
  end
end