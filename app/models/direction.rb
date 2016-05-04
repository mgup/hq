class Direction < ActiveRecord::Base
  belongs_to :department

  has_many :competitive_group_items, class_name: 'Entrance::CompetitiveGroupItem'
  has_many :min_scores, class_name: 'Entrance::MinScore'

  has_one :speciality, class_name: Speciality, foreign_key: :direction_id
  has_many :profiles, through: :speciality

  scope :for_campaign, -> (campaign) do
    joins(competitive_group_items: :competitive_group).
      where('competitive_groups.campaign_id = ?', campaign.id).
      group(:new_code).order(:name, :new_code)
  end

  scope :with_new_code, -> { where('new_code IS NOT NULL AND new_code != ""') }
  scope :for_aspirants, -> { where('new_code LIKE "%.06.%"') }
  scope :not_aspirants, -> { where('new_code NOT LIKE "%.06.%"') }
  scope :from_department, -> department_id { where(department_id: department_id) }
  scope :all_campaigns, -> { where('department_id IS NOT NULL') }

  def description
    "#{new_code} #{name}"
  end

  def master?
    '04' == new_code.split('.')[1]
  end

  def bachelor?
    '03' == new_code.split('.')[1]
  end

  def specialist?
    '05' == new_code.split('.')[1]
  end

  def aspirant?
    qualification_code == 70
  end

  def full_description
    "#{code+'.'+qualification_code.to_s+', ' if code} #{new_code if new_code} #{name}"
  end
end
