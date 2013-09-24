class Office::OrderTemplate < ActiveRecord::Base
  self.table_name = 'template'

  alias_attribute :id, :template_id
  alias_attribute :name, :template_name

  has_many :orders, class_name: Office::Order, foreign_key: :order_template

  has_many :xsl, -> { order('order_xsl_time DESC').limit(1) }, class_name: Office::OrderXsl, foreign_key: :order_xsl_template
  accepts_nested_attributes_for :xsl, update_only: false

  default_scope do
    where(template_active: 1).order(:template_name)
  end
end