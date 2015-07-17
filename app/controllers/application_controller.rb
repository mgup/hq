class ApplicationController < ActionController::Base

  before_filter :set_current_user
  def set_current_user
    User.current = current_user
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  before_filter :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :enable_profiler unless Rails.env.test?

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user || current_student)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:username, :user_login, :password, :remember_me)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :phone, :password,
               :password_confirmation, :current_password)
    end
  end

  def enable_profiler
    Rack::MiniProfiler.authorize_request if can?(:manage, :all)
  end
end
