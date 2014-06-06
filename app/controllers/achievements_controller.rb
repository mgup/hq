# Контроллер, отвечающий за работу с отчётами об эффективности НПР.
class AchievementsController < ApplicationController
  load_resource except: [:update, :destroy, :validate, :validate_selection, :validate_social, :validate_additional]
  authorize_resource

  def periods ; end

  def index
    @period = AchievementPeriod.where(year: params[:year],
                                      semester: params[:semester]).first

    if @period.nil?
      redirect_to periods_achievements_path
      return
    end

    @achievements = @period.achievements.by(current_user)

    a = Activity.all.includes(:activity_group, :activity_type,
                              :activity_credit_type)
    @groups = a.group_by { |activ| activ.activity_group.name }

    @already_closed = @period.achievement_reports.by_user(current_user)
      .only_relevant.any?
  end

  def show ; end

  def new ; end

  def test ; end

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

  def edit ; end

  def update
    @achievement = Achievement.unscoped.find(params[:id])

    unless @achievement.new?
      @achievement.status = Achievement::STATUS_NEW
    end

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
    redirect_to achievements_path(year: @period.year,
                                  semester: @period.semester)
  end

  def validate
    @achievements = Achievement.validatable_by(current_user)

    if current_user.is?(:subdepartment)
      @subdepartment_achievements = Achievement.for_subdepartment(current_user).group_by { |a| [a.user, a.period] }
    end
  end

  # Валидация показателей эффективности про приёмке и профориентационной работе.
  def validate_selection
    @achievements = Achievement.in_selection
  end

  # Валидация показателей эффективности по социальной работе.
  def validate_social
    @achievements = Achievement.in_social
  end

  # Подтверждение показателей эффективности по дополнительным поручениям.
  def validate_additional
    redirect_to '/' unless can?(:validate_additional, Achievement)

    @year = params[:year] || Study::Discipline::CURRENT_STUDY_YEAR

    # Определяем, какой институт возглавляет текущий пользователь.
    deps = [Department::IPIT, Department::IIDIZH, Department::IKIM, Department::IGRIK]
    @current_department = nil
    current_user.department_ids.each do |d|
      @current_department = d if deps.include?(d)
    end

    @achievements = Achievement.in_additional(current_user, @current_department,
                                              params[:subdepartment], @year)
  end

  def calculate
    @departments = [Department::IGRIK, Department::IPIT,
                    Department::IIDIZH, Department::IKIM]
    params[:department] ||= @departments[0]

    @department = Department.find(params[:department] || @departments[0])

    @sums = Mgup::Achievements.sums(params[:department])
    @sums_without_additional = Mgup::Achievements.sums_without_additional(
      params[:department]
    )
  end

  def calculate_salary
    redirect_to root_path unless can?(:manage, :all)

    params[:department] ||= 7
    if '0' == params[:department]
      @department = Department.new
    else
      @department = Department.find(params[:department])
    end

    params[:e] ||= 0.2
    params[:e] = params[:e].to_f

    @lower = 0.48613
    funds = {
      '7' => 1128688.0,
      '5' => 1481719.0,
      '6' => 2125790.0,
      '3' => 3048000.0,
      '0' => 7784197.0
    }
    @prev_fund = funds[params[:department]]
    @curr_fund = @lower * @prev_fund

    if '0' == params[:department]
      @salaries = Salary::Salary201403.includes(:user, :department).joins(:user)
        .order('department.department_id, last_name_hint, first_name_hint, patronym_hint')
      @sums = Mgup::Achievements.sums(params[:department])
    else
      @salaries = Salary::Salary201403.where(faculty_id: params[:department])
        .includes(:user, :department).joins(:user)
        .order('department.department_id, last_name_hint, first_name_hint, patronym_hint')
      @sums = Mgup::Achievements.sums(params[:department])
    end


    # Вычисляем баллы для рейтинга, используя информацию о защитах и заведующих кафедрой.

    # Считаем медиану среди незащищённых и не заведующих кафедрой.
    ok_credits = []
    @salaries.find_all { |s| s.touchable? }.each do |s|
      s.final_credit = s.credits || @sums[s.user.id] || 0.0
      ok_credits << s.final_credit
    end
    @first_median = median(ok_credits)

    # Ставим всем счастливчикам балл, равный ручным баллам или первой медиане.
    @salaries.find_all { |s| s.lucky? }.each { |s| s.final_credit = s.credits || @first_median }

    # Разбиваем все сотрудников на группы, по кафедрам.
    @salaries.group_by { |s| s.department.id }.each do |i, department|
      credits = []
      department.each { |s| credits << s.final_credit unless s.king? }
      avg = credits.sum / credits.length

      department.find_all { |s| s.king? }.each do |s|
        s.final_credit = 0.5 * ((s.credits || @sums[s.user.id] || @first_median) + avg)
      end
    end

    # Считаем вторую медиану.
    second_median_credits = []
    @salaries.each { |s| second_median_credits << s.final_credit }
    @second_median = median(second_median_credits)

    # Обрабатываем тех, у кого фиксированные надбавки.
    credits_fund = @curr_fund
    @salaries.find_all { |s| s.new_premium? }.each do |salary|
      salary.final_premium = salary.new_premium
      credits_fund -= salary.final_premium
    end

    minimal_credit = @salaries.map(&:final_credit).reject { |i| 0 == i }.min
    @b = Math.log(params[:e].to_f) / (minimal_credit - @second_median)

    fund_to_normalize = 0.0
    @salaries.find_all { |s| s.new_premium.nil? }.each do |salary|
      unless 0 == salary.final_credit
        f = 1.0 + vvv(salary.final_credit - @second_median, @b)
        fund_to_normalize += @lower * salary.previous_premium.to_f * f
      end
    end

    @alpha = credits_fund / fund_to_normalize

    @salaries.find_all { |s| s.new_premium.nil? }.each do |salary|
      if 0 == salary.final_credit
        salary.final_premium = 0
      else
        f = 1.0 + vvv(salary.final_credit - @second_median, @b)
        salary.final_premium = @alpha * @lower * salary.previous_premium.to_f * f
      end
    end
  end

  def salary_igrik
    redirect_to root_path unless can?(:manage, :all)

    @salaries = Salary::Salary201403.where(faculty_id: Department::IGRIK).joins(:user)
                  .order('department_id, last_name_hint, first_name_hint, patronym_hint')

    draft_sums = Mgup::Achievements.sums(Department::IGRIK)
    @sums = []
    @sums_without_untouchables = []
    @salaries.each do |salary|
      pair = draft_sums.find { |p| salary.user_id == p[0] }
      if pair
        credit = pair[1]
        @sums << pair
      else
        credit = 0
        @sums << [salary.user_id, 0]
      end

      unless salary.untouchable? || 0 == credit
        @sums_without_untouchables << pair
      end
    end

    @lower = 0.48613

    @prev_fund = 1128688.0
    @curr_fund = @lower * @prev_fund

    @credits = @sums.map { |p| p[1] }
    @credits_min = @sums_without_untouchables.map { |p| p[1] }.min
    @credits_max = @sums_without_untouchables.map { |p| p[1] }.max
    #@median = median(@credits)
    @median = median(@sums_without_untouchables.map { |p| p[1] })

    @e = params[:e] ? params[:e].to_f : 0.05
    @b = Math.log(@e) / (@credits_min.to_f - @median.to_f)

    untouchables_fund = 0.0
    @salaries.each do |salary|
      if salary.untouchable?
        if salary.new_premium != nil
          untouchables_fund += salary.new_premium
        else
          untouchables_fund += @lower * salary.previous_premium
        end
      end
    end

    right_fund = @curr_fund - untouchables_fund

    current_fund = 0.0
    @salaries.each do |salary|
      unless salary.untouchable? || 0 == @sums.find { |p| salary.user_id == p[0] }[1]
        s = @sums.find { |p| p[0] == salary.user.id }
        credit = s ? s[1] : 0
        credit = credit.round(5)

        current_premium = @lower * salary.previous_premium.to_f * (1.0 + vvv(credit.to_f - @median.to_f, @b))
        current_fund += current_premium
      end
    end

    @alpha = right_fund / current_fund
  end

  def median(array)
    sorted = array.sort
    len = sorted.length

    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def sgn(number)
    return  1 if number > 0
    return -1 if number < 0

    return  0
  end

  def vvv(x, b)
    sgn(x) * (1 - Math::E**(-b * x.abs))
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
    @count_reports = ActiveRecord::Base.connection.execute('
SELECT department_sname AS `Кафедра`,
       COUNT(
         CASE
           WHEN achievement_reports.achievement_period_id = 1
           THEN achievement_reports.id
         END
       ) AS `Количество`,
       COUNT(
         CASE
           WHEN achievement_reports.achievement_period_id = 2
           THEN achievement_reports.id
         END
       ) AS `Количество2`
FROM achievement_reports
JOIN user ON user.user_id = achievement_reports.user_id
JOIN department ON department_id = user.user_department
WHERE achievement_reports.relevant IS TRUE
GROUP BY  department_sname ORDER BY COUNT(achievement_reports.id) ASC;
    ')
    @all_by_activity = ActiveRecord::Base.connection.execute('
SELECT name AS `Название`, COUNT(achievements.id) AS `Количество`
FROM `achievements`
JOIN activities ON achievements.activity_id = activities.id
GROUP BY activities.id ORDER BY  COUNT(achievements.id);
    ')
    @all_by_activity_group = ActiveRecord::Base.connection.execute('
SELECT activity_groups.name AS `Название`, COUNT(achievements.id) AS `Количество`
FROM `achievements`
JOIN activities ON achievements.activity_id = activities.id
JOIN activity_groups on activity_groups.id = activity_group_id
GROUP BY activity_groups.id
ORDER BY COUNT(achievements.id);
    ')
    @count_by_academic = ActiveRecord::Base.connection.execute('
SELECT department_sname AS `Кафедра`, COUNT(achievements.id) AS `Количество`,
       COUNT(DISTINCT user.user_id) AS `2`,
       (
         SELECT COUNT(user_id) from user
         WHERE user_department = department_id
       ) as `4`
FROM `achievements`
JOIN user ON user.user_id = achievements.user_id
JOIN department ON department_id = user.user_department
GROUP BY department_id
ORDER BY COUNT(achievements.id) ASC;
    ')
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
    params.fetch(:achievement, {})
      .permit(:description, :achievement_period_id, :activity_id, :value, :cost,
              :status, :comment)
  end
end
