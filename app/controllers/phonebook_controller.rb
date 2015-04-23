class PhonebookController < ApplicationController
  before_filter :load_departments, only: :index
  before_filter :load_department, except: :index

  helper PhonebookHelper

  def index
  end

  private

  def load_departments
    @departments = Department.active
  end

  def load_department
    @department = Department.find(params[:id])
    @positions = @department.positions.for_phonebook
  end
end
