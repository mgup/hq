class Entrance::Contract < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  enum sides: { bilateral: 2, trilateral: 3, trilateral_with_organization: 4 }

  belongs_to :application, class_name: 'Entrance::Application'

  after_create do |contract|
    Entrance::Log.create entrant_id: contract.application.entrant.id,
                         user_id: User.current.id,
                         comment: "Оформлен договор #{contract.id}."
  end

  def prices
    EducationPrice.
      for_year(created_at.to_date.year).
      for_form(application.education_form_id).
      for_direction(application.direction.id).sort_by { |p| p.course }
  end

  # Разовый платеж, который совершается в рамках договора.
  def one_time_payment
    10 == application.form ? prices.first.price : prices.first.price / 2
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

  def self.stats
    self.find_each.inject({ total:    0,
                            received: 0,
                            expected: 0 }) do |r, contract|
      r[:total] += contract.prices.map(&:price).sum
      r[:expected] += contract.one_time_payment
      r[:received] += contract.student.total_payments

      r
    end
  end

  def paid?
    student.total_payments >= one_time_payment
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.contract {
        xml.id_   id
        xml.number number
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end
