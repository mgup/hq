class UsersController < ApplicationController
  before_filter do
    params[:user] &&= user_params
  end

  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def edit ; end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :email, :phone)
  end
end