class Office::Cause < ActiveRecord::Base
  self.table_name = 'template_cause'

  alias_attribute :id, :template_cause_id
  alias_attribute :pattern, :template_cause_pattern
  alias_attribute :patternf, :template_cause_patternf

  belongs_to :template, class_name: Office::OrderTemplate, foreign_key: :template_cause_template

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.cause {
        xml.id_   id
        xml.pattern  pattern
        xml.patternf  patternf
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end

end