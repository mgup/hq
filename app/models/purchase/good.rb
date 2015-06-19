class Purchase::Good < ActiveRecord::Base
  has_many :purchase_line_items, class_name: 'Purchase::LineItem', foreign_key: :good_id, dependent: :destroy
  validates :name, presence: { message: 'не может быть пустым!'}
end
