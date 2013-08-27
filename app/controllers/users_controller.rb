class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]

  def index
    @users = User.all.page(params[:page])
  end

  def new
     @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save && @user.update_name(user_name_params)
      redirect_to users_path
    else
      render action: :new
    end
  end

  def edit ; end

  def update
    if @user.update(user_params) && @user.update_name(user_name_params)
      redirect_to users_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def show ; end

  def profile
    @user = User.find @current_user
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :email, :phone)
  end

  def user_name_params
    params.require(:user).permit(:last_name_ip, :first_name_ip, :patronym_ip,
                                 :last_name_rp, :first_name_rp, :patronym_rp,
                                 :last_name_dp, :first_name_dp, :patronym_dp,
                                 :last_name_vp, :first_name_vp, :patronym_vp,
                                 :last_name_tp, :first_name_tp, :patronym_tp,
                                 :last_name_pp, :first_name_pp, :patronym_pp)
  end
end