class Social::ApplicationsController < ApplicationController
  load_and_authorize_resource class: My::Support

  def index
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    @applications = @applications.page(params[:page] || 1)
  end
end