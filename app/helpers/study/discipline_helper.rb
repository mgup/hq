module Study::DisciplineHelper
  def study_year(first_year)
    "#{first_year}/#{first_year + 1}"
  end
end