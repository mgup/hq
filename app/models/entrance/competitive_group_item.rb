class Entrance::CompetitiveGroupItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  belongs_to :direction
  belongs_to :education_type

  has_many :applications, class_name: 'Entrance::Application'
  has_many :packed_applications, -> { where(packed: true)}, class_name: 'Entrance::Application'
  has_many :entrants, through: :applications

  scope :from_direction, -> direction_id { where(direction_id: direction_id) }

  scope :for_7_july, -> { where('competitive_group_id IN (336147,373005,336157,372999,336158,373000,336159,336160)') }
  scope :for_10_july, -> { where(competitive_group_id: [336142, 372989, 336152, 386069, 372998, 372997, 373016, 336153, 412150, 372996, 373017, 336154, 336139, 372986, 336140, 372987, 336143, 372990, 373009, 336150, 373012, 372994, 373010, 336151, 336146, 373013, 336155, 373015, 372995, 373014, 336156, 373001, 336141, 373002, 372988, 373003, 336145, 373004, 372992, 336144, 372991, 373006, 336148, 373008, 372993, 373007, 336149]) }
  # ИПИТ:
  #scope :for_10_july, -> { where(competitive_group_id: [336142, 372989, 336139, 372986, 336140, 372987, 336143, 372990, 373001, 336141, 373002, 372988, 373003, 336145, 373004, 372992, 336144, 372991]) }

  scope :for_25_july, -> { where(competitive_group_id: [336142, 372989, 336152, 386069, 372998, 372997, 373016, 336153, 412150, 372996, 373017, 336154, 336139, 372986, 336140, 372987, 336143, 372990, 373009, 336150, 373012, 372994, 373010, 336151, 336146, 373013, 336155, 373015, 372995, 373014, 336156, 373001, 336141, 373002, 372988, 373003, 336145, 373004, 372992, 336144, 372991, 373006, 336148, 373008, 372993, 373007, 336149]) }

  scope :for_master_25_july, -> { where(competitive_group_id: [372989,372998,372997,372996,372986,372987,372990,372994,372995,372988,372992,372991,372993]) }
  scope :for_master_1_august, -> { where(competitive_group_id: [372989,372998,372997,372996,372986,372987,372990,372994,372995,372988,372992,372991,372993]) }

  # scope :for_10_and_25_july, -> { where('competitive_group_id IN (192420,192669,192679,192682,192684,192686,192688,192691,192694,193640,199761)') }
  # scope :for_15_july, -> { where('competitive_group_id IN (201408,201422,201424,201439,201443)') }
  # scope :for_7_july_aspirants, -> { where('competitive_group_id IN (201453,201457,201458,201627,201630,201634,201637,201640,201649,201661,201668,201673,201676,201679,201686,201688,201692,201694,201695,201697,201699,201702,201704,201706)') }
  # scope :for_7_july_crimea, -> { where('competitive_group_id IN (228818,228819,230882,230883,230884,230885,230886,247821,247836,247844,247847,247850,247854,247857,247862,247867,247893,247897,247898,247900,247903,247905,247911,247913,247923,247929,247934,247937,247938)') }

  attr_accessor :UID

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
  
  def budget?
    number_budget_o > 0 || number_budget_oz > 0 || number_budget_z > 0 || number_quota_o > 0 || number_quota_oz > 0 || number_quota_z > 0
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

  def total_budget_o
    number_budget_o + number_quota_o
  end

  def total_budget_oz
    number_budget_oz + number_quota_oz
  end

  def total_budget_z
    number_budget_z + number_quota_z
  end

  def total_paid_o
    number_paid_o
  end

  def total_paid_oz
    number_paid_oz
  end

  def total_paid_z
    number_paid_z
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
