class Office::OrderTemplate < ActiveRecord::Base
  self.table_name = 'template'

  alias_attribute :id, :template_id
  alias_attribute :name, :template_name

  has_many :orders, class_name: Office::Order, foreign_key: :order_template
  has_many :reasons, class_name: Office::Reason, foreign_key: :template_reason_template
  has_many :causes, class_name: Office::Cause, foreign_key: :template_cause_template

  has_one :current_xsl, -> { order('order_xsl_time DESC').limit(1) }, class_name: Office::OrderXsl, foreign_key: :order_xsl_template

  has_one :used_xsl, -> { order('order_xsl_time DESC').limit(1) }, class_name: Office::OrderXsl, foreign_key: :order_xsl_template

  has_many :xsl, -> { order('order_xsl_time DESC').limit(1) }, class_name: Office::OrderXsl, foreign_key: :order_xsl_template
  accepts_nested_attributes_for :xsl, update_only: false

  default_scope do
    where(template_active: 1).order(:template_name)
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.order_template {
        xml.id_   id
        xml.name  name
        xml.reasons {
          reasons.each { |reason| xml << reason.to_nokogiri.root.to_xml }
        }
        xml.causes {
          causes.each { |cause| xml << cause.to_nokogiri.root.to_xml }
        }
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end