class Social::ApplicationsController < ApplicationController
  load_and_authorize_resource class: My::Support

  def index
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month
    params[:accepted] ||= false

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    if params[:accepted]
      @applications = @applications.where(accepted: true)
    end

    params[:causes] ||= []
    params[:strict] ||= 0
    unless params[:causes].empty?
      @applications = @applications.with_causes(params[:causes], !params[:strict].to_i.zero?)
    end

    @applications = @applications.page(params[:page] || 1)
  end
end