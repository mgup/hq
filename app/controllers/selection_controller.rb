class SelectionController < ApplicationController

  def index

  end

  def contract
    @students = []
    Student.off_budget.entrants.with_contract.each do |student|
      p = Finance::PaymentType.from_student(student).where(finance_payment_type_year: 2013).first
      cost = Finance::Price.where(finance_price_payment_type: p).collect{ |p| p.price * 2}

      @students << { student: student, cost: cost}
    end
  end

end