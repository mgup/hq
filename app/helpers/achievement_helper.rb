module AchievementHelper
  def achievements_credits(achievements)
    only_cost = true
    credits = achievements.inject(0) do |res, a|
      if a.cost?
        res += a.cost
      else
        only_cost = false
      end
      res
    end

    res = "#{prettify(credits)} #{Russian::p(prettify(credits), 'балл', 'балла', 'баллов', 'балла')}"

    res += ' + ?' unless only_cost

    res
  end
end