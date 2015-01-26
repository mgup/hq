class Mgup::Achievements
  def self.sums(faculty_id = Department::IGRIK)
    if '0' == faculty_id
      achievements = Achievement.in_department(0, only_accepted: true)
    else
      achievements = Achievement.in_department(faculty_id, only_accepted: true)
    end
    calculate_result(achievements)
  end

  def self.sums_without_additional(faculty_id = Department::IGRIK)
    achievements = Achievement.in_department(faculty_id, only_accepted: true, without_additional: true)
    calculate_result(achievements)
  end

  private

  def self.calculate_result(achievements)
    by_user = achievements.group_by { |a| a.user_id }

    by_user_and_year = {}
    by_user.each do |user_id, achievements|
      by_user_and_year[user_id] = achievements.group_by { |a| a.period.year }
    end

    by_user_and_year_summed = {}
    by_user_and_year.each do |user_id, by_year|
      by_user_and_year_summed[user_id] = {}

      by_year.each do |year, achievements|
        by_user_and_year_summed[user_id][year] = achievements.map(&:cost).sum
      end
    end

    result = {}
    by_user_and_year_summed.each do |user, years|
      sum = 0
      sum += years[2013] if years[2013]
      sum += 0.8 * years[2012] if years[2012]

      result[user] = sum
    end

    result
  end
end
