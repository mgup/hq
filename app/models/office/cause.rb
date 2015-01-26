class Office::Cause < ActiveRecord::Base
  self.table_name = 'template_cause'

  alias_attribute :id, :template_cause_id
  alias_attribute :pattern, :template_cause_pattern
  alias_attribute :patternf, :template_cause_patternf

  belongs_to :template, class_name: Office::OrderTemplate, foreign_key: :template_cause_template

  def to_nokogiri
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.cause do
        xml.id_   id
        xml.pattern  pattern
        xml.patternf  patternf
      end
    end

    builder.doc
  end

  delegate :to_xml, to: :to_nokogiri
end