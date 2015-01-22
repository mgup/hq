class RolesController < ApplicationController
  load_and_authorize_resource

  def index
    @roles = Role.unscoped.ordered
  end

  def new ; end

  def edit ; end

  def create
    if @role.save
      redirect_to roles_path, notice: 'Роль успешно создана.'
    else
      render action: :new
    end
  end

  def update
    if @role.update(resource_params)
      respond_to do |format|
        format.html { redirect_to roles_path, notice: 'Изменения сохранены.' }
        format.js   { render 'toggle_active' if resource_params.include?(:active) }
      end


    else
      render action: :edit
    end
  end

  def destroy
    @role.destroy

    redirect_to roles_path
  end

  def resource_params
    params.fetch(:role, {}).permit(:name, :title, :description, :active)
  end
end