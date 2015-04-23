class DepartmentsController < ApplicationController

  load_resource except: [:index]
  authorize_resource

  def index
    @departments = Department.only_main
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
    @department.department_active = 0
    @department.save!

    redirect_to departments_path
  end

  # Перенос всех сотрудников из @department в подразделение params[:to].
  def combine
    User.where(user_department: @department.id).update_all(user_department: params[:to])
    Position.where(acl_position_dismission: nil, acl_position_department: @department.id).update_all(acl_position_department: params[:to])

    @department.department_active = 0
    @department.save!

    redirect_to edit_department_path(Department.find(params[:to]))
  end

  def resource_params
    params.fetch(:department, {}).permit(:name, :abbreviation, :parent, :phone)
  end
end
