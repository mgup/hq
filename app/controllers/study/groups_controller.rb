class Study::GroupsController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def create
    if params[:id]
      redirect_to study_group_progress_path(params[:id])
    end
  end

  def update ; end

  private

  def student_params
    params.require(:groups)
  end
end