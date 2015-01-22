class Curator::TaskTypesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @task_type.save
      redirect_to curator_task_types_path, notice: 'Создан новый тип заданий.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @task_type.update(resource_params)
      redirect_to curator_task_types_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:curator_task_type, {}).permit(:name, :description)
  end
end