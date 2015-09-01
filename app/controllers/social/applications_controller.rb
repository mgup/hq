class Social::ApplicationsController < ApplicationController
  load_and_authorize_resource class: My::Support

  def index
    init_params
    params[:empty] ||= 0

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    if (params[:accepted].to_i.zero? && params[:accepted].to_i.zero? && !params[:causes] && (params[:last_name] == '' || !params[:last_name]))
      @close = @applications.open == [] ? 2 : 1
    else
      @close = 0
    end

    find_a_d_or_from_causes(@applications, params[:accepted], params[:deferred], params[:causes], params[:strict])

    unless params[:empty].to_i.zero?
      @applications = @applications.open
    end

    if params[:last_name]
      @applications = @applications.with_last_name(params[:last_name])
    end

    @applications = @applications.page(params[:page] || 1)
  end

  def lists
    init_params

    @applications = @applications.where(support_year:  params[:year])
    @applications = @applications.where(support_month: params[:month])

    find_a_d_or_from_causes(@applications, params[:accepted], params[:deferred], params[:causes], params[:strict])

    params[:lists] ||= []
    unless params[:lists].empty? || params[:lists] == ['']
      @applications = @applications.send("list_#{params[:lists]}")
    end

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def close_receipt
    params[:year]  ||= 2015
    params[:month] ||= 9
    applications = @applications.where(support_year:  params[:year])
    applications = applications.where(support_month: params[:month])
    applications = applications.where(accepted: false)
    applications = applications.where(deferred: false)

    applications.each do |a|
      a.update_attribute :deferred, true
    end

    redirect_to social_applications_path
  end

  private

  def init_params
    params[:year]  ||= 2015
    params[:month] ||= 3
    params[:accepted] ||= 0
    params[:deferred] ||= 0
    params[:causes] ||= []
    params[:strict] ||= 0
  end

  def find_a_d_or_from_causes(apps, accepted = 0, deferred = 0, causes = [], strict = 0)
    @applications = apps
    unless accepted.to_i.zero?
      @applications = @applications.where(accepted: true)
    end

    unless deferred.to_i.zero?
      @applications = @applications.where(deferred: true)
    end

    unless causes.empty? || causes == ['']
      @applications = @applications.with_causes(causes, !strict.to_i.zero?)
    end
  end

end