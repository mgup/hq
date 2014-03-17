class Curator::TaskUsersController < ApplicationController
  load_and_authorize_resource

  def update
    @task_user.update(resource_params)
    redirect_to curator_task_path(@task_user.task)
  end

  def destroy

  end

  def resource_params
    params.fetch(:curator_task_user, {}).permit(:curator_task_id, :user_id, :status, :accepted)
  end
end