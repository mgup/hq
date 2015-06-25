class Purchase::Supplier < ActiveRecord::Base
  has_many :purchase_line_items, class_name: 'Purchase::LineItem', foreign_key: :supplier_id, dependent: :destroy
  validates :name, presence: { message: 'не может быть пустым!' }
  validates_associated :purchase_line_items
end
