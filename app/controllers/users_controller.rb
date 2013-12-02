class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    params[:page] ||= 1

    @users = @users.by_name(params[:name]) if params[:name]

    @users = @users.page(params[:page])
  end

  def new
     @user = User.new
     @user.build_fname
     @user.build_iname
     @user.build_oname
  end

  def create
    #authorize! :create, User
    #raise resource_params.inspect
    #raise '123'
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
    #raise '123'
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
        positions_attributes: [:id, :appointment_id, :acl_position_role,
                               :acl_position_department, :started_at, :_destroy]
    )
  end

  def filter
    if params
      @users = User.filter(params)
    else
      @users = User.all
    end
    respond_to do |format|
      format.js
    end
  end

  def medical_requests
    require 'csv'
    @data = CSV.read '/Users/storkvist/Sites/mgup/med_preps.txt', { col_sep: "\t" }
  end

  def see_with_eyes
    @user = User.find params[:user_id]
    sign_out current_user
    sign_in_and_redirect @user, event: :authentication
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  #def require_no_authentication
  #  if current_user.is_developer?
  #    return true
  #  else
  #    return super
  #  end
  #end
end