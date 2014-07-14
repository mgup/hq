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

  def delegate_full_name
    [delegate_last_name, delegate_first_name, delegate_patronym].join(' ')
  end

  def delegate_short_name
    "#{delegate_last_name} #{delegate_first_name[0]}. #{delegate_patronym[0]}."
  end

  def student_id
    number.split('-')[1].to_i
  end

  def student
    Student.find(student_id)
  end

  def self.calculate_contract_stats
    total, received, expected = 0, 0, 0
    self.find_each do |contract|
      total += contract.prices.map{|x| x.price}.sum
      expected += (10 == contract.application.competitive_group_item.form ? contract.prices.first.price : contract.prices.first.price/2)
      received += contract.student.total_payments
    end

    { total: total,
      received: received,
      expected: expected }
  end
end