class PasswordController < ApplicationController
  before_filter :authenticate_user!, except: :index
  def index
    user = User.find(params[:id])
    password = params[:user_password]
    if (::Digest::SHA2.hexdigest(user.user_password + ENV['SECRET_KEY'])== password)
        sign_in_and_redirect user, :event => :authentication
    else
      redirect_to root_path
    end
  end
end