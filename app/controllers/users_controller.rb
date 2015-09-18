class UsersController < ApplicationController
  load_resource
  authorize_resource except: [:rating]

  def index
    # raise params inspect
    params[:page] ||= 1
    @users = @users.from_appointment(params[:appointment]) if params[:appointment]
    @users = @users.by_name(params[:name]) if params[:name]
    @users = @users.by_department(params[:department]) if params[:department]
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

  def destroy
    if current_user.is?(:developer)
      @user.destroy
    end

    redirect_to users_path
  end


  def profile
    @user = User.find @current_user
  end

  def resource_params
    params.fetch(:user, {}).permit(
      :username, :email, :phone, :password, :active,
      fname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
      iname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
      oname_attributes: [:ip, :rp, :dp, :vp, :tp, :pp],
      positions_attributes: [:id, :appointment_id, :acl_position_role,
                            :acl_position_department, :started_at, :primary, :_destroy]
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
    @data = CSV.read '/Users/storkvist/Sites/mgup/med_preps2.txt', { col_sep: "\t" }
    #@data = CSV.read '/home/anna/med_preps.txt', { col_sep: "\t" }
  end

  def see_with_eyes
    @user = User.find params[:user_id]
    sign_out current_user
    sign_in_and_redirect @user, event: :authentication
  end

  def without_med
    @users = User.teachers.find(:all, conditions: ['user_id not in (?)', Event.first.users.collect{|u| u.id}]).sort_by{|u| u.full_name}
    respond_to do |format|
      format.xlsx
    end
  end

  def rating
    authorized = false
    # Проверка пользователя на право доступа к информации.
    if current_user != @user
      if current_user.is?(:subdepartment)
        if @user.departments.include?(
          current_user.departments_with_role(:subdepartment).first
        )
          authorized = true
        end
      end

      if current_user.is?(:dean)
        current_user.departments_with_role(:dean).each do |department|
          department.subdepartments.each do |subdepartment|
            authorized = true if @user.departments.include?(subdepartment)
          end
        end
      end
    else
      authorized = true
    end

    redirect_to root_path unless authorized
  end

  def department

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