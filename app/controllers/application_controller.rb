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

  # before_filter do
  #   raise ActionController::RoutingError.new('Нужно подождать') unless can?(:manage, :all)
  # end

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

  private

  # def render_error(status, exception)
  #   respond_to do |format|
  #     format.html { render template: "application/error_#{status}",
  #                          status: status,
  #                          locals: { exception: exception, request: request } }
  #     format.all { render nothing: true, status: status }
  #   end
  # end

  def render_report(report)
    respond_to do |format|
      format.html { render inline: report.render(format: :html), layout: true }
      format.pdf { render body: report.render(format: :pdf) }
    end
  end
end
