class Office::OrderReason < ActiveRecord::Base
  self.table_name = 'order_reason'

  alias_attribute :id, :order_reason_id

  belongs_to :order, class_name: Office::Order, foreign_key: :order_reason_order
  belongs_to :reason, class_name: Office::Reason, foreign_key: :order_reason_reason
end