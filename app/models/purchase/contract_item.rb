class Purchase::ContractItem < ActiveRecord::Base
  self.table_name_prefix = 'purchase_'

  belongs_to :purchase_contract, :class_name => 'Purchase::Contract', foreign_key: :contract_id
  belongs_to :purchase_line_item, :class_name => 'Purchase::LineItem', foreign_key: :line_item_id
end
