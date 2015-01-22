class EventCategoriesController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new

  end

  def create
    if @event_category.save
      redirect_to event_categories_path, notice: 'Создана новая категория.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @event_category.update(resource_params)
      redirect_to event_categories_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:event_category, {}).permit(:name, :description)
  end
end