class Office::OrderMeta < ActiveRecord::Base
  self.table_name = 'order_meta'

  alias_attribute :id,      :order_meta_id
  alias_attribute :type,    :order_meta_type
  alias_attribute :object,  :order_meta_object
  alias_attribute :text,    :order_meta_text
  alias_attribute :pattern, :order_meta_text

  belongs_to :order, class_name: Office::Order, foreign_key: :order_meta_order

  def to_nokogiri
    doc = Nokogiri::XML::Builder.new { |xml|
      xml.meta {
        xml.id_      id
        xml.type     type
        xml.object   object
        xml.text     text
        xml.pattern  pattern
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end