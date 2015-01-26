class ActivityCreditTypesController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new

  end

  def create
    if @activity_credit_type.save
      redirect_to activity_credit_types_path, notice: 'Тип балла показателей эффективности НПР создана.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @activity_credit_type.update(resource_params)
      redirect_to activity_credit_types_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:activity_credit_type, {}).permit(:name, :description)
  end
end