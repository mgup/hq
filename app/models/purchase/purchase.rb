class Purchase::Purchase < ActiveRecord::Base
  self.table_name_prefix = 'purchase_'

  RESPONSIBLE_POSITION_ROLES = [2, 22]

  PAYMENT_BUDGET = 1
  PAYMENT_OFF_BUDGET = 2

  has_many :purchase_line_items, class_name: 'Purchase::LineItem', foreign_key: :purchase_id, dependent: :destroy
  belongs_to :department, foreign_key: :dep_id
  belongs_to :user, foreign_key: :purchase_introduce
  accepts_nested_attributes_for :purchase_line_items, allow_destroy: true

  validates :dep_id, presence: { message: 'Поле не может быть пустым!' }
  validates :payment_type, presence: {message: 'Поле не может быть пустым' }

  enum status: { обработка: 0, подпись: 1, зарегистрирован: 2 }

  scope :off_budget, -> { where(payment_type:  PAYMENT_OFF_BUDGET) }
  scope :budget, -> { where(payment_type: PAYMENT_BUDGET) }
end
