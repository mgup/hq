module AchievementHelper
  def achievements_credits(achievements)
    only_cost = true
    credits = achievements.inject(0) do |res, a|
      unless a.refused?
        if a.activity.need_cost? && a.cost.zero?
          only_cost = false
        elsif a.activity.need_cost?
          res += a.cost
        elsif a.activity.flexible_credits?
          only_cost = false
        else
          res += a.activity.credit
        end
      end

      res
    end

    res = "#{prettify(credits)} #{Russian::p(prettify(credits), 'балл', 'балла', 'баллов', 'балла')}"

    res += ' + ?' unless only_cost

    res
  end

  def sgn(number)
    return  1 if number > 0
    return -1 if number < 0

    return  0
  end

  def vvv(x, b)
    sgn(x) * (1 - Math::E**(-b * x.abs))
  end

  def salary_type_icon(salary)
    case salary.type
    when Salary::Salary201403::TYPE_OK
      '&#x2713;'.html_safe
    when Salary::Salary201403::TYPE_LUCKY
      '&#x263C;'.html_safe
    when Salary::Salary201403::TYPE_KING
      '&#x2654;'.html_safe
    end
  end

  def achievement_status(achievement = @achievement)
    case achievement.status
      when Achievement::STATUS_NEW
        'не подтверждено'
      when Achievement::STATUS_REFUSED
        'отказано в подтверждении'
      when Achievement::STATUS_ACCEPTED
        'подтверждено'
      when Achievement::STATUS_ACCEPTED_FINAL
        'подтверждено'
    end
  end
end
