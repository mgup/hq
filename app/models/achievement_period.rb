class AchievementPeriod < ActiveRecord::Base
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
end