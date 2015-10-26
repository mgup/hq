class Purchase::Contract < ActiveRecord::Base
  self.table_name_prefix = 'purchase_'

  has_many :purchase_contract_items, :class_name => 'Purchase::ContractItem', foreign_key: :contract_id, dependent: :destroy
  validates :number, presence: { message: 'не может быть пустым!'}
end
