class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_filter :authenticate_student

  before_filter :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # before_filter :authorize_developer

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  before_filter :enable_profiler unless Rails.env.test?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:username, :user_login, :password, :remember_me)
    end
  end

  #def authenticate_student
  #  #raise authenticate_user!.inspect
  #  #redirect_to study_groups_path if student_signed_in?
  #end

  # def authorize_developer
  #   authorize! :manage, :all if user_signed_in?
  # end

  def enable_profiler
    Rack::MiniProfiler.authorize_request if can?(:manage, :all)
  end
end
