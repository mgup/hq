class SelectionController < ApplicationController

  def index

  end

  def contract
    @students = []
    Student.paid.entrants.with_contract.each do |student|
      p = Finance::PaymentType.from_student(student).where(finance_payment_type_year: 2013).first
      cost = Finance::Price.where(finance_price_payment_type: p).collect{ |p| p.price * 2}
      date = student.contract.date.strftime('%d.%m.%Y')

      @students << { student: student, cost: cost, date: date}
    end
  end

end