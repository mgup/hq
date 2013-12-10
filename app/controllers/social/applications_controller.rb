class Social::ApplicationsController < ApplicationController
  load_and_authorize_resource class: My::Support

  def index
    #params[:year]  ||= Date.today.year
    #params[:month] ||= Date.today.month
    params[:year]  ||= 2013
    params[:month] ||= 12
    params[:accepted] ||= false

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    if params[:accepted]
      @applications = @applications.where(accepted: true)
    end

    if params[:deferred]
      @applications = @applications.where(deferred: true)
    end

    params[:causes] ||= []
    params[:strict] ||= 0
    unless params[:causes].empty?
      @applications = @applications.with_causes(params[:causes], !params[:strict].to_i.zero?)
    end

    if params[:last_name]
      @applications = @applications.with_last_name(params[:last_name])
    end

    @applications = @applications.page(params[:page] || 1)
  end

  def lists
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month
    params[:accepted] ||= false

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    if params[:accepted]
      @applications = @applications.where(accepted: true)
    end

    if params[:deferred]
      @applications = @applications.where(deferred: true)
    end

    params[:lists] ||= []
    unless params[:lists].empty?
      @applications = @applications.send("list_#{params[:lists]}")
    end
  end

  def print_list
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month
    params[:accepted] ||= false

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    if params[:accepted]
      @applications = @applications.where(accepted: true)
    end

    params[:lists] ||= []
    unless params[:lists].empty?
      @applications = @applications.send("list_#{params[:lists]}")
    end

  end
end