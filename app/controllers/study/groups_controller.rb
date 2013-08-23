class Study::GroupsController < ApplicationController
  skip_before_filter :authenticate_user! , :only => [:index]
  load_resource

  def index
    authorize! :index, :progress_group
  end

  def create
    if params[:id]
      redirect_to study_group_progress_path(params[:id])
    end
  end

  def update ; end

  private

  def group_params
    params.require(:groups)
  end
end