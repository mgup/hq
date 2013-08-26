module Study::DisciplineHelper
  def study_year(first_year)
    "#{first_year}/#{first_year + 1}"
  end

  def study_term(term)
    case term
      when 1
        'осенний семестр'
      when 2
        'весенний семестр'
    end
  end
end