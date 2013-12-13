class Social::ApplicationsController < ApplicationController
  load_and_authorize_resource class: My::Support

  def index
    #params[:year]  ||= Date.today.year
    #params[:month] ||= Date.today.month
    params[:year]  ||= 2013
    params[:month] ||= 12
    params[:accepted] ||= false
    params[:deferred] ||= false

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    if (!params[:accepted] && !params[:deferred] && !params[:causes] && (params[:last_name] == '' || !params[:last_name]))
      @close = @applications.open == [] ? 2 : 1
    else
      @close = 0
    end

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
    params[:deferred] ||= false

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

    params[:lists] ||= []
    unless params[:lists].empty?
      @applications = @applications.send("list_#{params[:lists]}")
    end
  end

  def close_receipt
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month
    applications = @applications.where(support_year:  params[:year])
    applications = applications.where(support_month: params[:month])
    applications = applications.where(accepted: false)
    applications = applications.where(deferred: false)

    applications.each do |a|
      a.update_attribute :deferred, true
    end

    redirect_to social_applications_path
  end

  def print_list
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month
    params[:accepted] ||= 0
    params[:deferred] ||= 0

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    unless params[:accepted].to_i.zero?
      @applications = @applications.where(accepted: true)
    end

    unless params[:deferred].to_i.zero?
      @applications = @applications.where(deferred: true)
    end

    params[:causes] ||= []
    params[:strict] ||= 0

    unless params[:causes].empty?
      @applications = @applications.with_causes(params[:causes], !params[:strict].to_i.zero?)
    end

    params[:lists] ||= []
    unless params[:lists].empty?
      @applications = @applications.send("list_#{params[:lists]}")
    end
  end
end