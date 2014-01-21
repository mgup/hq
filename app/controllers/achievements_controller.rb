class AchievementsController < ApplicationController
  load_resource except: [:update, :destroy, :validate]
  authorize_resource

  def periods
    @periods = AchievementPeriod.all
  end

  def index
    @period = AchievementPeriod.where(year: params[:year],
                                      semester: params[:semester])
                               .first

    if @period.nil?
      redirect_to periods_achievements_path
      return
    end

    unless @period.active?
      redirect_to periods_achievements_path, notice: 'Приём данных по указанному периоду завершён.'
    end

    @achievements = @period.achievements.by(current_user)

    a = Activity.all.includes(:activity_group, :activity_type, :activity_credit_type)
    @groups = a.group_by { |activ| activ.activity_group.name }

    @already_closed = @period.achievement_reports.by_user(current_user).only_relevant.any?
  end

  def show

  end

  def new

  end

  def create
    @achievement.user_id = current_user.id

    if @achievement.save
      @period = @achievement.period

      respond_to do |format|
        format.html do
          redirect_to achievements_path(year: @period.year, semester: @period.semester),
                      notice: 'Результат работы сохранён.'
        end

        format.js do
          @achievements = @achievement.period.achievements.by(current_user)
        end
      end
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    @achievement = Achievement.unscoped.find(params[:id])

    if @achievement.update(resource_params)
      respond_to do |format|
        format.js
        format.html { redirect_to achievements_path, notice: 'Изменения сохранены.' }
      end
    else
      render action: :edit
    end
  end

  def destroy
    @achievement = Achievement.unscoped.find(params[:id])
    @achievement.destroy

    @period = AchievementPeriod.find(params[:period])
    redirect_to achievements_path(year: @period.year, semester: @period.semester)
  end

  def validate
    @achievements = Achievement.validatable_by(current_user)

    if current_user.is?(:subdepartment)
      @subdepartment_achievements = Achievement.for_subdepartment(current_user).group_by { |a| [a.user, a.period] }
    end
  end

  def print
    @no_reports = ActiveRecord::Base.connection.execute("
      SELECT department_sname AS `Кафедра`,
             CASE WHEN user_name IS NULL or user_name = '' THEN CONCAT_WS(' ',
                   (SELECT dictionary.dictionary_ip FROM dictionary WHERE dictionary_id = user_fname  LIMIT 1),
                   (SELECT dictionary.dictionary_ip FROM dictionary WHERE dictionary_id = user_iname LIMIT 1),
                   (SELECT dictionary.dictionary_ip FROM dictionary WHERE dictionary_id = user_oname LIMIT 1))
                  ELSE user_name END AS `Преподаватель`
      FROM user JOIN acl_position ON acl_position.acl_position_user = user.user_id
                JOIN department ON department_id = user.user_department
      WHERE user.user_id NOT IN (SELECT user.user_id FROM user
                                JOIN achievement_reports ON  achievement_reports.user_id = user.user_id
                                WHERE achievement_reports.relevant IS TRUE)
      AND acl_position.acl_position_role IN (7,8) ORDER BY department_sname;
    ")
    @count_reports = ActiveRecord::Base.connection.execute("
      SELECT department_sname AS `Кафедра`,
      COUNT(CASE WHEN achievement_reports.achievement_period_id = 1 THEN achievement_reports.id END) AS `Количество`,
      COUNT(CASE WHEN achievement_reports.achievement_period_id = 2 THEN achievement_reports.id END) AS `Количество2`
      FROM achievement_reports JOIN user ON user.user_id = achievement_reports.user_id
        JOIN department ON department_id = user.user_department
      WHERE achievement_reports.relevant IS TRUE
      GROUP BY  department_sname ORDER BY COUNT(achievement_reports.id) ASC;
    ")
    @all_by_activity = ActiveRecord::Base.connection.execute("
    SELECT name AS `Название`, COUNT(achievements.id) AS `Количество`
    FROM `achievements`
      JOIN activities ON achievements.activity_id = activities.id
    GROUP BY activities.id ORDER BY  COUNT(achievements.id);
    ")
    @all_by_activity_group = ActiveRecord::Base.connection.execute("
      SELECT activity_groups.name AS `Название`, COUNT(achievements.id) AS `Количество`
      FROM `achievements`
        JOIN activities ON achievements.activity_id = activities.id
        JOIN activity_groups on activity_groups.id = activity_group_id
      GROUP BY activity_groups.id
      ORDER BY  COUNT(achievements.id);
    ")
    @count_by_academic = ActiveRecord::Base.connection.execute("
      SELECT department_sname AS `Кафедра`, COUNT(achievements.id) AS `Количество`,
      COUNT(DISTINCT user.user_id) AS `2`,
      (SELECT COUNT(user_id) from user WHERE user_department = department_id) as `4`
      FROM `achievements` JOIN user ON user.user_id = achievements.user_id
            JOIN department ON department_id = user.user_department
      GROUP BY department_id ORDER BY COUNT(achievements.id) ASC;
    ")
    @count_by_teacher = ActiveRecord::Base.connection.execute("
      SELECT department_sname AS `Кафедра`,
      CASE WHEN user_name IS NULL or user_name = '' THEN CONCAT_WS(' ',
                      (SELECT dictionary.dictionary_ip FROM dictionary WHERE dictionary_id = user_fname  LIMIT 1),
                      (SELECT dictionary.dictionary_ip FROM dictionary WHERE dictionary_id = user_iname LIMIT 1),
                      (SELECT dictionary.dictionary_ip FROM dictionary WHERE dictionary_id = user_oname LIMIT 1))
                      ELSE user_name END AS `Преподаватель`,
      COUNT(achievements.id) AS `Количество показателей`
      FROM `achievements` JOIN user ON user.user_id = achievements.user_id
      JOIN department ON department_id = user.user_department
      GROUP BY achievements.user_id ORDER BY department_sname ASC, COUNT(achievements.id) ASC;
    ")
  end

  def resource_params
    params.fetch(:achievement, {}).permit(:description, :achievement_period_id,
                                          :activity_id, :value, :cost, :status)
  end
end