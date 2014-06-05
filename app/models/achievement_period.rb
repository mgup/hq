class AchievementPeriod < ActiveRecord::Base
  RATIOS = { 1 => 1, 2 => 0.8, 3 => 0.4, 4 => 0.2 }

  has_many :achievements
  has_many :achievement_reports

  default_scope do
    order(year: :desc).order(active: :desc)
  end

  def description
    #"#{year}/#{year.to_i + 1} учебный год, #{semester} семестр"
    "#{year} календарный год и #{year - 1}/#{year} учебный год"
  end

  def active?
    active
  end

  # Коэффициент, с которым учитываются достижения отчёта.
  def ratio
    diff = Date.today.year - year

    # Если отчёту больше учитываемого количества лет, то он не учитывается.
    return 0 unless RATIOS.key?(diff)

    RATIOS[diff]
  end
end