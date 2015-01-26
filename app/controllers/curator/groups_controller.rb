class Curator::GroupsController < ApplicationController
  load_and_authorize_resource

  def create
    Curator::Group.create(resource_params)
    redirect_to users_path
  end

  def resource_params
    params.fetch(:curator_group, {}).permit(:group_id, :user_id, :start_date, :end_date)
  end
end