class Office::OrderXsl < ActiveRecord::Base
  self.table_name = 'order_xsl'

  alias_attribute :id,  :order_xsl_id
  alias_attribute :stylesheet, :order_xsl_content
  alias_attribute :last_edit, :order_xsl_time

  belongs_to :order_template, class_name: Office::OrderTemplate, foreign_key: :order_xsl_template
end