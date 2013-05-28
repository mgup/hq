class DepartmentsController < ApplicationController
  def index
  end

  def edit
    @department = Department.find params[:id]
  end
end