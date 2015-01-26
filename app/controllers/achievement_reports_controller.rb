class AchievementReportsController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show
    @report = AchievementReport.find(params[:id])
    @period = @report.achievement_period
    @achievements = @period.achievements.by(current_user).not_refused
    respond_to do |format|
      format.pdf
    end
  end

  def new

  end

  def create
    @achievement_report.user_id = current_user.id

    if @achievement_report.save!
      redirect_to periods_achievements_path
    end
  end

  def reopen
    @achievement_report.relevant = false
    @achievement_report.save!

    p = @achievement_report.achievement_period
    redirect_to achievements_path(year: p.year, semester: p.semester)
  end

  def resource_params
    params.fetch(:achievement_report, {}).permit(:achievement_period_id,
                                                 :user_id, :valid)
  end
end