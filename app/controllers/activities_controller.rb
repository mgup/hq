class ActivitiesController < ApplicationController
  load_and_authorize_resource

  def index
    a = @activities.includes(:activity_group, :activity_type, :activity_credit_type)
    @groups = a.group_by { |activ| activ.activity_group.name }
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
    params.fetch(:activity, {}).permit(:name, :description, :activity_group_id,
                                       :activity_type_id, :base, :base_name,
                                       :activity_credit_type_id, :credit,
                                       :unique, :placeholder, :role_id)
  end
end