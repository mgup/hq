class Office::OrderMeta < ActiveRecord::Base
  self.table_name = 'order_meta'

  alias_attribute :id,      :order_meta_id
  alias_attribute :type,    :order_meta_type
  alias_attribute :object,  :order_meta_object
  alias_attribute :text,    :order_meta_text
  alias_attribute :pattern, :order_meta_pattern

  belongs_to :order,
             class_name: 'Office::Order',
             foreign_key: :order_meta_order

  scope :for_entrance, -> { where(pattern: 'Конкурсная группа') }

  def to_nokogiri
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.meta do
        xml.id_      id
        xml.type     type
        xml.object   object
        if pattern == 'Группа' && order.template.id == Office::Order::PROBATION_TEMPLATE
          xml.value  Group.find(text).name
        else
        xml.value    text
        end
        xml.pattern  pattern
      end
    end

    builder.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end