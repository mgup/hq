module AchievementHelper
  def achievements_credits(achievements)
    only_fixed_credits = true
    credits = achievements.inject(0) do |res, a|
      if a.activity.fixed_credits?
        res += a.activity.credit
      else
        only_fixed_credits = false
      end

      res
    end

    res = "#{prettify(credits)} #{Russian::p(prettify(credits), 'балл', 'балла', 'баллов', 'балла')}"

    res += ' + ?' unless only_fixed_credits

    res
  end
end