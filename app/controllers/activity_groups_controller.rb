class ActivityGroupsController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new

  end

  def create
    if @activity_group.save
      redirect_to activity_groups_path, notice: 'Группа показателей эффективности НПР создана.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @activity_group.update(resource_params)
      redirect_to activity_groups_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:activity_group, {}).permit(:name, :description)
  end
end