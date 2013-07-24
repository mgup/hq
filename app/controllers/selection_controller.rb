class SelectionController < ApplicationController
  def index

  end

  def contract
    @students = Student.off_budget.entrants.with_contract
  end
end