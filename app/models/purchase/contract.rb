class Purchase::Contract < ActiveRecord::Base
  has_many :purchase_contract_items, :class_name => 'Purchase::ContractItem', foreign_key: :contract_id, dependent: :destroy
  has_many :purchase_line_items, :class_name => 'Purchase::LineItem', through: :purchase_contract_items
  belongs_to :purchase_suppliers, :class_name => 'Purchase::Supplier', foreign_key: :supplier_id
  accepts_nested_attributes_for :purchase_contract_items, allow_destroy: true

  validates :number, presence: { message: 'не может быть пустым!'}
end
