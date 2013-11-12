class ActivitiesController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new

  end

  def create
    if @activity.save
      redirect_to activities_path, notice: 'Показатель эффективности НПР создана.'
    else
      render action: :new
    end
  end


  def edit

  end

  def update
    if @activity.update(resource_params)
      redirect_to activities_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:activity, {}).permit(:name, :description, :activity_group_id)
  end
end