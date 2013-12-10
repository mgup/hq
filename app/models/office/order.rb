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
  alias_attribute :responsible,  :order_responsible

  belongs_to :template, class_name: Office::OrderTemplate,
                        foreign_key: :order_template

  has_many :students_in_order, class_name: Office::OrderStudent, foreign_key: :order_student_order
  has_many :students, class_name: Student, through: :students_in_order

  has_many :order_reasons, class_name: Office::OrderReason, foreign_key: :order_reason_order
  has_many :reasons, class_name: Office::Reason, through: :order_reasons

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

  def to_nokogiri
    doc = Nokogiri::XML::Builder.new { |xml|
      xml.order {
        xml.id_         id
        xml.version     version
        xml.responsible responsible
        xml.status      status
        xml << template.to_nokogiri.root.to_xml
        xml.students {
          students.each { |student| xml << student.to_nokogiri.root.to_xml }
        }
        xml.reasons {
          reasons.each { |reason| xml << reason.to_nokogiri.root.to_xml }
        }
        xml.text_
      }
    }.doc

    Nokogiri::XSLT(template.current_xsl.stylesheet).transform(doc)
  end

  def to_xml
    to_nokogiri.to_xml
  end

  def to_html
    xslt = Nokogiri::XSLT(File.read('lib/xsl/order_view.xsl'))
    xslt.transform(to_nokogiri).root.to_html.html_safe
  end
end