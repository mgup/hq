class AchievementPeriodsController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new

  end

  def create
    if @achievement_period.save
      redirect_to achievement_periods_path, notice: 'Период ввода достижений сохранён.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @achievement_period.update(resource_params)
      redirect_to achievement_periods_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:achievement_period, {}).permit(:year, :semester)
  end
end