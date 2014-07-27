pdf.text group.name

pdf.bounding_box([0, pdf.cursor], width: 510) do
  pdf.bounding_box([0, pdf.bounds.top], width: 500) do
    pdf.text 'Пофамильные списки поступающих', style: :bold, size: 16
    # pdf.stroke_bounds
  end

  pdf.bounding_box([520,  pdf.bounds.top], width: 200) do
    pdf.text 'УТВЕРЖДАЮ'
    pdf.text 'Председатель Приемной комиссии'
    pdf.text 'МГУП имени Ивана Федорова'
    pdf.move_down 10
    pdf.text '_____________________ / К. В. Антипов'

    # pdf.stroke_bounds
  end

  # pdf.stroke_bounds
end
pdf.move_down 40

a_out_of_competition = []
a_special_rights = []
a_contest = []

group.items.first.applications.for_rating.each do |a|
  if 0 != a.pass_min_score
    if a.out_of_competition
      a_out_of_competition << a
    elsif a.special_rights
      a_special_rights << a
    else
      a_contest << a
    end
  end
end

pdf.font_size = 8

# Без вступительных испытаний.
if a_out_of_competition.any?
  pdf.text 'Список поступающих без вступительных испытаний', size: 14
  data = [['', 'Рег. номер', 'Поступающий', 'Причина']]
  a_out_of_competition.each_with_index do |a, i|
    data << [i + 1, a.number, a.entrant.full_name, a.benefits.first.temp_text]
  end

  pdf.table data, width: pdf.bounds.width
  pdf.move_down 40
end

exam_names = group.test_items.order(:entrance_test_priority).collect do |t|
  t.exam.name
end

# Квота.
if a_special_rights.any?
  pdf.text 'Список поступающих по квоте приема лиц, имеющих особое право',
           size: 14
  data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Сумма').flatten]
  a_special_rights.sort(&Entrance::Application.sort_applications).each_with_index do |a, i|
    data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitexams.map(&:score).sum]
  end

  pdf.table data, width: pdf.bounds.width
  pdf.move_down 40
end

# Общий конкурс.
if a_contest.any?
  pdf.text 'Список поступающих по общему конкурсу',
           size: 14
  data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Сумма').flatten]
  a_contest.sort(&Entrance::Application.sort_applications).each_with_index do |a, i|
    data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitexams.map(&:score).sum]
  end

  pdf.table data, width: pdf.bounds.width
end