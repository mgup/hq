class Purchase::Good < ActiveRecord::Base
  has_many :purchase_line_items, class_name: 'Purchase::LineItem', foreign_key: :good_id, dependent: :destroy
  belongs_to :department, foreign_key: :department_id

  validates :name, presence: { message: 'не может быть пустым!'}

  default_scope do
    order('name ASC')
  end
end
