class Purchase::Good < ActiveRecord::Base
  self.table_name_prefix = 'purchase_'

  has_many :purchase_line_items, class_name: 'Purchase::LineItem', foreign_key: :good_id, dependent: :destroy
  belongs_to :department, foreign_key: :department_id

  validates :name, presence: { message: 'не может быть пустым!'}
=begin
  default_scope do
    joins('INNER JOIN purchase_line_items AS pli ON pli.good_id = purchase_goods.id')
      .joins('INNER JOIN purchase_purchases AS pp ON pp.id = pli.purchase_id')
      .where('purchase_goods.department_id = ?', @current_user.departments.map {|d|  d.parent? ? Department.find(d.parent).id : d.id }).order('name ASC')
  end
=end

  default_scope do
    order('name ASC')
  end
end
