class Entrance::CompetitiveGroupItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  belongs_to :direction
  belongs_to :education_level

  has_many :applications, class_name: 'Entrance::Application'
  has_many :packed_applications, -> { where(packed: true)}, class_name: 'Entrance::Application'
  has_many :entrants, through: :applications

  scope :from_direction, -> direction_id { where(direction_id: direction_id) }

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