class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  load_and_authorize_resource except: [:create]

  def index
    @users = User.all.page(params[:page])
  end

  def new
     @user = User.new
     @user.build_fname
     @user.build_iname
     @user.build_oname
  end

  def create
    authorize! :create, User
    #raise resource_params.inspect
    @user = User.new(resource_params)
    if @user.save
      redirect_to users_path, notice: 'Сотрудник успешно добавлен.'
    else
      render action: :new
    end
  end

  def edit
    if @user.fname == nil
      @user.build_fname
      @user.build_iname
      @user.build_oname
    end
  end

  def update
    @user = User.all.includes(:positions).find(params[:id])
    if @user.update(resource_params)
      redirect_to users_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def show ; end


  def profile
    @user = User.find @current_user
  end

  def resource_params
    params.fetch(:user, {}).permit(
        :username, :email, :phone, :password,
        fname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
        iname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
        oname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
        positions_attributes: [:id, :title, :acl_position_role, :acl_position_department, :appointment, :_destroy]
    )
  end

  private

  def set_user
    @user = User.find params[:id]
  end

end