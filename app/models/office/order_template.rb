class Office::OrderTemplate < ActiveRecord::Base
  self.table_name = 'template'

  alias_attribute :id, :template_id
  alias_attribute :name, :template_name

  has_many :orders, class_name: 'Office::Order', foreign_key: :order_template, primary_key: :template_id
end