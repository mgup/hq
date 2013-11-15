module AchievementHelper
  def achievements_credits(achievements)
    credits = achievements.inject(0) do |res, a|
      res += a.activity.credit
      res
    end

    "#{prettify(credits)} #{Russian::p(prettify(credits), 'балл', 'балла', 'баллов', 'балла')}"
  end
end