class Purchase::LineItem < ActiveRecord::Base
  belongs_to :purchase_goods, :class_name => 'Purchase::Good', foreign_key: :good_id
  belongs_to :purchase_purchases, :class_name => 'Purchase::Purchase', foreign_key: :purchase_id
  has_many :purchase_contract_items, :class_name => 'Purchase::ContractItem', foreign_key: :line_item_id

  # проверка на уникальность товара в заявке
  validates :good_id, uniqueness: { scope: :purchase_id,
                                    message: 'Товар не должен повторяться' }

  enum period: { '12 мес' => 0, '24 мес' => 1, '36 мес' => 2 }
  enum published: { опубликован: 0, не_о: 1 }
  enum contracted: { законтрактирован: 0, не_з: 1 }
  enum delivered: { поставлен: 0, не_п: 1 }
  enum paid: { оплачен: 0, не_оп: 1 }
end
