class AchievementPeriod < ActiveRecord::Base
  has_many :achievements

  default_scope do
    order(:year, :semester)
  end
end