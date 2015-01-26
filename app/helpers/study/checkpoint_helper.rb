module Study::CheckpointHelper
  def checkpoint_type(checkpoint)
    case checkpoint.type
      when Study::Checkpoint::TYPE_LECTURE
        'Лекция'
      when Study::Checkpoint::TYPE_SEMINAR
        'Практическое или лабораторное занятие'
      when Study::Checkpoint::TYPE_CHECKPOINT
        "Контрольная точка «#{checkpoint.name}»"
    end
  end

  def render_checkpoints_calendar(discipline, options = {})
    content_tag :div do
      content_tag :table, class: 'table semester-calendar' do
        tags = []

        tags << '<tr><td class="border-none"></td>'.html_safe
        (Date.today.beginning_of_week..Date.today.end_of_week).each do |d|
          tags << %Q(<th class="border-none">#{l(d, format: '%a')}</th>).html_safe
        end
        tags << '</tr>'.html_safe

        first_day = Kernel.const_get("MGUP_STUDY_START_#{discipline.year}_#{discipline.semester}")
        last_day  = Kernel.const_get("MGUP_STUDY_END_#{discipline.year}_#{discipline.semester}")
        (first_day..last_day).each do |d|
          # Если первый день семестра выпадает не на понедельник — добавляем
          # в начало строки пустые ячейки.
          if first_day == d || d.monday?
            tags << '<tr>'.html_safe
            tags << render_month_td(d, first_day)
          end

          if first_day == d && !d.monday?
            d.cwday.times { tags << '<td class="border-none border-bottom"></td>'.html_safe }
          end

          tags << render_day(d, first_day, last_day)

          if d.sunday?
            tags << '</tr>'.html_safe
          end

          # Если последний день семестра выпадает не на воскресенье — добавляем
          # в конец строки пустые ячейки.
          if last_day == d
            (7 - d.cwday).times { tags << '<td class="border-none border-top"></td>'.html_safe }
            tags << '</tr>'.html_safe
          end
        end
        tags.join.html_safe
      end
    end
  end

  private

  def render_day(date, first_study_date = nil, last_study_date = nil)
    classes = %w(day border-none)
    classes << 'border-right' if date == date.end_of_month || date.sunday?
    classes << 'border-left'  if date == date.beginning_of_month && !date.monday?

    classes << 'border-bottom'if date.cweek == date.end_of_month.cweek
    classes << 'border-top'   if date.cweek == date.beginning_of_month.cweek

    classes << 'border-left' if date == first_study_date
    classes << 'border-right' if date == last_study_date

    classes << 'border-top' if date.cweek == first_study_date.cweek

    content_tag :td, class: classes.join(' '), data: { date: l(date) } do
      date.day.to_s
    end
  end

  def render_month_td(date, first_study_date = nil)
    if is_first_monday_in_month?(date, first_study_date)
      if date.beginning_of_month < first_study_date
        first_date = first_study_date
      else
        first_date = date.beginning_of_month
      end

      mondays_in_month = (first_date..date.end_of_month).inject(0) do |count, day|
        count += 1 if day.monday?
        count
      end

      classes = %w(border-none border-top border-bottom border-left month)

      content_tag :td, rowspan: mondays_in_month, class: classes.join(' ') do
        l(date, format: '%b')
      end
    end
  end

  def is_first_monday_in_month?(date, first_study_date)
    return false unless date.monday?

    if date.beginning_of_month < first_study_date
      first_date = first_study_date
    else
      first_date = date.beginning_of_month
    end

    return date.yesterday.downto(first_date).find_all { |d| d.monday? }.empty?
  end
end