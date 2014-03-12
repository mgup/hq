class Curator::TasksController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    @task = Curator::Task.new(resource_params)
    if @task.save
      redirect_to curator_tasks_path, notice: 'Задание успешно добавлено.'
    else
      render action: :new
    end
  end

  def resource_params
    params.fetch(:curator_task, {}).permit(:name, :description, :curator_task_type_id, :status,
                                    task_users_attributes: [:id, :user_id, :status, :accepted, :'_destroy'])
  end
end