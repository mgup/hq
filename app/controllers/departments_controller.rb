class DepartmentsController < ApplicationController
load_and_authorize_resource

  def index
    @departments = Department.unscoped.ordered
  end

  def show ; end

  def new ; end

  def edit ; end

  def create
    if @department.save
      redirect_to departments_path, notice: 'Департамент успешно создан.'
    else
      render action: :new
    end
  end

  def update
    if @department.update(resource_params)
      respond_to do |format|
        format.html { redirect_to departments_path, notice: 'Изменения сохранены.' }
      end


    else
      render action: :edit
    end
  end

  def destroy
    @department.destroy

    redirect_to departments_path
  end

  def resource_params
    params.fetch(:department, {}).permit(:name, :abbreviation, :parent)
  end
end
