class Office::Reason < ActiveRecord::Base
  self.table_name = 'template_reason'

  alias_attribute :id, :template_reason_id
  alias_attribute :pattern, :template_reason_pattern

  belongs_to :template, class_name: Office::OrderTemplate, foreign_key: :template_reason_template

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.reason {
        xml.id_   id
        xml.pattern  pattern
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end


end