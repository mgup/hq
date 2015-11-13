class Purchase::Purchase < ActiveRecord::Base
  #self.table_name_prefix = 'purchase_'

  RESPONSIBLE_POSITION_ROLES = [2, 22]

  PAYMENT_BUDGET = 1
  PAYMENT_OFF_BUDGET = 2

  has_many :purchase_line_items, class_name: 'Purchase::LineItem', foreign_key: :purchase_id, dependent: :destroy
  has_many :purchase_contract_items, :class_name => 'Purchase::ContractItem', through: :purchase_line_items
  belongs_to :department, foreign_key: :dep_id
  belongs_to :user, foreign_key: :purchase_introduce
  accepts_nested_attributes_for :purchase_line_items, allow_destroy: true

  validates :dep_id, presence: { message: 'Поле не может быть пустым!' }
  validates :payment_type, presence: {message: 'Поле не может быть пустым' }

  enum status: { обработка: 0, подпись: 1, зарегистрирован: 2 }

  scope :off_budget, -> { where(payment_type:  PAYMENT_OFF_BUDGET) }
  scope :budget, -> { where(payment_type: PAYMENT_BUDGET) }

  scope :search_keyword, -> (key, p) {
    joins('LEFT JOIN purchase_line_items AS li ON li.purchase_id = purchase_purchases.id')
    .joins('LEFT JOIN purchase_goods AS g ON g.id = li.good_id')
    .where('g.name LIKE ? AND purchase_purchases.id = ? ', key, p)
  }
end
