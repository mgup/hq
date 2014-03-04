class Mgup::Achievements
  def self.sums(faculty_id = Department::IGRIK)
    achievements = Achievement.in_department(faculty_id, true)

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

    by_user_and_year_summed
  end

  def self.sums_without_additional(faculty_id = Department::IGRIK)

  end
end