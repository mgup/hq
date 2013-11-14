class AchievementPeriod < ActiveRecord::Base
  has_many :achievements

  default_scope do
    order(:year, :semester).order(active: :desc)
  end

  def description
    "#{year}/#{year.to_i + 1} учебный год, #{semester} семестр"
  end

  def active?
    active
  end
end