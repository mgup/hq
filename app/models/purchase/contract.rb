class Purchase::Contract < ActiveRecord::Base
  has_many :purchase_contract_items, :class_name => 'Purchase::ContractItem', foreign_key: :contract_id, dependent: :destroy
  has_many :purchase_line_items, :class_name => 'Purchase::LineItem', through: :purchase_contract_items

  #validates :number, presence: { message: 'не может быть пустым!'}
end
