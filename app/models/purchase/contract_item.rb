class Purchase::ContractItem < ActiveRecord::Base
  #self.table_name_prefix = 'purchase_'
  belongs_to :purchase_contracts, :class_name => 'Purchase::Contract', foreign_key: :contract_id
  belongs_to :purchase_line_items, :class_name => 'Purchase::LineItem', foreign_key: :line_item_id
  accepts_nested_attributes_for :purchase_contracts
end
