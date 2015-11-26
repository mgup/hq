class Purchase::Purchase < ActiveRecord::Base
  RESPONSIBLE_POSITION_ROLES = [2, 22] # роли, которые могут пользоваться модулем (ЦИОТ и ОИС)

  # источник финансирования, бюджет пока не активен
  PAYMENT_BUDGET = 1
  PAYMENT_OFF_BUDGET = 2

  has_many :purchase_line_items, class_name: 'Purchase::LineItem', foreign_key: :purchase_id, dependent: :destroy
  accepts_nested_attributes_for :purchase_line_items, allow_destroy: true # nested form
  has_many :purchase_contract_items, :class_name => 'Purchase::ContractItem', through: :purchase_line_items
  belongs_to :department, foreign_key: :dep_id
  belongs_to :user, foreign_key: :purchase_introduce

  validates :dep_id, presence: { message: 'Поле не может быть пустым!' }
  validates :payment_type, presence: {message: 'Поле не может быть пустым' }

  enum status: { обработка: 0, подпись: 1, зарегистрирован: 2 }

  # фильтры по источникам финансирования
  scope :off_budget, -> { where(payment_type:  PAYMENT_OFF_BUDGET) }
  scope :budget, -> { where(payment_type: PAYMENT_BUDGET) }
end
