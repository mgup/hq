class Curator::TasksController < ApplicationController
  load_resource
  authorize_resource except: :actual

  def index
    unless params[:draft].to_i.zero?
      @tasks = @tasks.drafts
    end
    unless params[:publication].to_i.zero?
      @tasks = @tasks.publications
    end
    @tasks = @tasks.from_name(params[:name]) if params[:name]

    @tasks = @tasks.sort_by(&:status) if params[:draft].to_i.zero? and params[:publication].to_i.zero?
  end

  def analyze
   @rows = []
   User.curators.each do |curator|
      row = []
      row << curator
     Curator::Task.publications.each do |task|
        result = task.task_users.by_user(curator).last
        row << result
      end

      @rows << row
    end
  end

  def print_tasks
    @rows = []
    User.curators.each do |curator|
      row = []
      row << curator
      row << (!curator.current_groups.empty? ? curator.current_groups.collect{|g| g.group.name}.join(', ') : '-')
      Curator::Task.without_drafts.each do |task|
        result = task.task_users.by_user(curator).last
        row << result
      end
      @rows << row
    end
  end

  def actual
    authorize! :actual, :curator_tasks
    @task_users = current_user.task_users

    unless params[:accepted].to_i.zero?
      @task_users = @task_users.where(accepted: true)
    end
    unless params[:neversaw].to_i.zero?
      @task_users = @task_users.where(status: Curator::TaskUser::STATUS_NEVER_SAW)
    end
    unless params[:reopened].to_i.zero?
      @task_users = @task_users.where(status: Curator::TaskUser::STATUS_REOPENED)
    end
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
    params.fetch(:curator_task, {}).permit(:name, :description, :curator_task_type_id, :status, :report,
                                    task_users_attributes: [:id, :user_id, :status, :accepted, :'_destroy'])
  end
end