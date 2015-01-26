class PositionsController < ApplicationController
  def create
    user = User.find position_params[:user]
    role = Role.find position_params[:role]
    department = Department.find position_params[:department]
    position = user.positions.new role: role, department: department,
                             title: position_params[:title],
                             appointment: position_params[:appointment]
    position.save
    redirect_to user
  end

  private

  def position_params
    params.require(:position).permit(:user, :title, :role, :department, :appointment)
  end
end