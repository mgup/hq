class Curator::TasksController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def show
    @task_users = @task.task_users

    unless params[:accepted].to_i.zero?
      @task_users = @task_users.where(accepted: true)
    end
    unless params[:neversaw].to_i.zero?
      @task_users = @task_users.where(status: Curator::TaskUser::STATUS_NEVER_SAW)
    end
    unless params[:finished].to_i.zero?
      @task_users = @task_users.where(status: Curator::TaskUser::STATUS_FINISHED)
    end
  end

  def create
    @task = Curator::Task.new(resource_params)
    if @task.save
      if params[:curators]
        @task.users = User.find(params[:curators])
        @task.save
      end
      redirect_to curator_tasks_path, notice: 'Задание успешно добавлено.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @task.update(resource_params)
      if params[:curators]
        @task.users = User.find(params[:curators])
        @task.save
      end

      redirect_to curator_tasks_path, notice: 'Задание успешно отредактировано.'
    else
      render action: :edit
    end
  end

  def resource_params
    params.fetch(:curator_task, {}).permit(:name, :description, :curator_task_type_id, :status,
                                    task_users_attributes: [:id, :user_id, :status, :accepted, :'_destroy'])
  end
end