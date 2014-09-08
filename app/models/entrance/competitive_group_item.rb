class Entrance::CompetitiveGroupItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  belongs_to :direction
  belongs_to :education_type

  has_many :applications, class_name: 'Entrance::Application'
  has_many :packed_applications, -> { where(packed: true)}, class_name: 'Entrance::Application'
  has_many :entrants, through: :applications

  scope :from_direction, -> direction_id { where(direction_id: direction_id) }

  scope :for_5_july, -> { where('competitive_group_id IN (189106,193585,193593,193597,193610,193629,193635)') }
  scope :for_10_and_25_july, -> { where('competitive_group_id IN (192420,192669,192679,192682,192684,192686,192688,192691,192694,193640,199761)') }
  scope :for_15_july, -> { where('competitive_group_id IN (201408,201422,201424,201439,201443)') }
  scope :for_7_july_aspirants, -> { where('competitive_group_id IN (201453,201457,201458,201627,201630,201634,201637,201640,201649,201661,201668,201673,201676,201679,201686,201688,201692,201694,201695,201697,201699,201702,201704,201706)') }
  scope :for_7_july_crimea, -> { where('competitive_group_id IN (228818,228819,230882,230883,230884,230885,230886,247821,247836,247844,247847,247850,247854,247857,247862,247867,247893,247897,247898,247900,247903,247905,247911,247913,247923,247929,247934,247937,247938)') }

  def direction_name
    direction.name
  end

  def description
   "#{direction_name}, #{form_name} форма, #{budget_name}"
  end

  def form
    (number_budget_o > 0 || number_paid_o > 0 || number_quota_o > 0) ? 11 : ((number_budget_oz > 0 || number_paid_oz > 0 || number_quota_oz > 0) ? 12 : 10)
  end

  def form_name
    (number_budget_o > 0 || number_paid_o > 0 || number_quota_o > 0) ? 'очная' : ((number_budget_oz > 0 || number_paid_oz > 0 || number_quota_oz > 0) ? 'очно-заочная' : 'заочная')
  end

  def payed?
    number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0
  end

  def budget_name
    (number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0) ? 'по договорам' : 'бюджет'
  end

  def budget
    (number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0) ? 2 : 1
  end

  def distance?
    number_budget_z > 0 || number_paid_z > 0 || number_quota_z > 0
  end

  def total_number
    number_budget_o + number_budget_oz + number_budget_z + number_paid_o + number_paid_oz + number_paid_z
  end

  def quota_number
    number_quota_o + number_quota_oz + number_quota_z
  end

  def matrix_form
    case form
      when 11
        101
      when 12
        102
      else 10
        103
    end
  end

  def to_nokogiri(protocol_name)
    Nokogiri::XML::Builder.new do |xml|
      xml.protocol do
        xml.id_     id
        xml.name    protocol_name
        xml.form    matrix_form
        xml.speciality Speciality.from_direction(direction)
        xml.applications do
          applications.each { |ap| xml << ap.to_nokogiri.root.to_xml }
        end
      end
    end
  end

  def to_xml(protocol_name)
    to_nokogiri(protocol_name).to_xml
  end
end