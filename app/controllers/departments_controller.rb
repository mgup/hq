class DepartmentsController < ApplicationController
  before_filter do
    params[:department] &&= department_params
  end

  before_action :set_department, only: [:edit, :update]

  def index ; end

  def edit ; end

  def update
    if @department.update(department_params)
      redirect_to departments_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  private

  def set_department
    @department = Department.find params[:id]
  end

  def department_params
    params.require(:department).permit(:name, :abbreviation, :parent)
  end
end