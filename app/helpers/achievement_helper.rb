module AchievementHelper
  def achievements_credits(achievements)
    has_dynamic_credits = false

    credits = achievements.inject(0) do |res, a|
      has_dynamic_credits = true if a.activity.dynamic_credits?

      if a.activity.flexible_credits?
        has_dynamic_credits = true
      else
        res += a.activity.credit
      end
      res
    end

    res = "#{prettify(credits)} #{Russian::p(prettify(credits), 'балл', 'балла', 'баллов', 'балла')}"

    res += ' + ?' if has_dynamic_credits

    res
  end
end