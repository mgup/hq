class Social::ApplicationsController < ApplicationController
  load_and_authorize_resource class: My::Support

  def index
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    params[:causes] ||= []
    params[:strict] ||= 0
    unless params[:causes].empty?
      @applications = @applications.with_causes(params[:causes], !params[:strict].to_i.zero?)
    end

    @applications = @applications.page(params[:page] || 1)
  end
end