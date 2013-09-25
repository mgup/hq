class Office::Order < ActiveRecord::Base
  self.table_name = 'order'

  STATUS_DRAFT    = 1
  STATUS_UNDERWAY = 2
  STATUS_SIGNED   = 3

  alias_attribute :id,      :order_id
  alias_attribute :version, :order_revision
  alias_attribute :number,  :order_number
  alias_attribute :status,  :order_status
  alias_attribute :editing_date, :order_editing
  alias_attribute :signing_date, :order_signing

  belongs_to :template, class_name: Office::OrderTemplate,
                        foreign_key: :order_template

  has_many :students_in_order, class_name: Office::OrderStudent, foreign_key: :order_student_order
  has_many :students, class_name: Student, through: :students_in_order

  scope :drafts, -> { where(order_status: STATUS_DRAFT) }
  scope :underways, -> { where(order_status: STATUS_UNDERWAY) }

  def draft?
    STATUS_DRAFT == status
  end

  def underway?
    STATUS_UNDERWAY == status
  end

  def signed?
    STATUS_SIGNED == status
  end

  def full_id
    "#{id}–#{version}"
  end

  def name
    template.name
  end

  def to_xml
    #xml = ::Builder::XmlMarkup.new
    #xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
    #xml.order do |order|
    #
    #end
    #
    #xml
    Nokogiri::XML::Builder.new { |xml|
      xml.order {
        xml.id_     id
        xml.version version
        xml.department {
          
        }
      }
    }.to_xml
  end
end