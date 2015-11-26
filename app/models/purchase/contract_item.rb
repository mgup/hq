class Purchase::ContractItem < ActiveRecord::Base
  belongs_to :purchase_contracts, :class_name => 'Purchase::Contract', foreign_key: :contract_id
  belongs_to :purchase_line_items, :class_name => 'Purchase::LineItem', foreign_key: :line_item_id
end
