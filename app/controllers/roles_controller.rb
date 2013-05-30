class RolesController < ApplicationController
  before_action :set_role, only: [:edit, :update]

  def index
    @roles = Role.all
  end

  def edit ; end

  def update
    if @role.update(role_params)
      redirect_to roles_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  private

  def set_role
    @role = Role.find params[:id]
  end

  def role_params
    params.require(:role).permit(:name, :description)
  end
end