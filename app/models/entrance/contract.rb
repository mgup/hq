class Entrance::Contract < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  enum sides: { bilateral: 2, trilateral: 3 }

  belongs_to :application, class_name: 'Entrance::Application'

  def prices
    EducationPrice.
      for_year(created_at.to_date.year).
      for_form(application.competitive_group_item.form).
      for_direction(application.direction.id).sort_by { |p| p.course }
  end

  def total_price
    prices.map(&:price).reduce(:+)
  end
end
