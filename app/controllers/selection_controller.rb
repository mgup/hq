class SelectionController < ApplicationController
  def index

  end

  def contract
    authorize! :contract, :students

    @students = Student.off_budget.entrants.with_contract
  end
end