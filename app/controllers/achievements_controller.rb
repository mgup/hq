class AchievementsController < ApplicationController
  load_and_authorize_resource

  def periods
    @periods = AchievementPeriod.all
  end

  def index
    @period = AchievementPeriod.where(year: params[:year], semester: params[:semester]).first
    unless @period.active?
      redirect_to periods_achievements_path, notice: 'Приём данных по указанному периоду завершён.'
    end

    a = Activity.all.includes(:activity_group, :activity_type, :activity_credit_type)
    @groups = a.group_by { |activ| activ.activity_group.name }
  end

  def show

  end

  def new

  end

  def create
    if @achievement.save
      redirect_to achievements_path, notice: 'Результат работы сохранён.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @achievement.update(resource_params)
      redirect_to achievements_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy

  end

  def resource_params
    params.fetch(:achievement, {}).permit(:description)
  end
end