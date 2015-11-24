class Purchase::Supplier < ActiveRecord::Base
  has_many :purchase_contracts, class_name: 'Purchase::Contract', foreign_key: :supplier_id, dependent: :destroy
  validates :name, presence: { message: 'не может быть пустым!' }
end
