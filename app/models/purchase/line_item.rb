class Purchase::LineItem < ActiveRecord::Base
  belongs_to :purchase_goods, :class_name => 'Purchase::Good', foreign_key: :good_id
  belongs_to :purchase_suppliers, :class_name => 'Purchase::Supplier', foreign_key: :supplier_id
  belongs_to :purchase_purchases, :class_name => 'Purchase::Purchase', foreign_key: :purchase_id

  enum measure: {час: 0, день: 1, мес: 2, шт: 3} # единица измерения
  enum period: {'12 мес' => 0, '24 мес' => 1}
  enum published: {опубликован: 0, не_о: 1}
  enum contracted: {законтрактирован: 0, не_з: 1}
  enum delivered: {поставлен: 0, не_п: 1}
  enum paid: {оплачен: 0, не_оп: 1}

  scope :statistic, -> (good, user_dep) {
    joins('LEFT JOIN purchase_goods AS g ON good_id = g.id')
      .joins('LEFT JOIN purchase_purchases AS p ON purchase_id = p.id')
      .joins('LEFT JOIN department as d ON p.dep_id = d.department_id')
      .where(:good_id => good).where('d.department_name LIKE ?', user_dep)
  }

  scope :keyword_search, -> (params) {
    joins('LEFT JOIN purchase_purchases as p ON purchase_id = p.id')
      .joins('LEFT JOIN purchase_goods as g ON good_id = g.id')
      .where('g.name LIKE ? OR p.number LIKE ?',
            "%#{params[:search_keyword]}%", "%#{params[:search_keyword]}%")
  }
end
