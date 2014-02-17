module SimpleCalendarHelper

  def calendar_for(year, month, selected = nil, options = {})
    content_tag :div, style: 'border: 1px solid #dddddd;', class: 'simple-calendar' do
      content_tag :table, class: 'table semester-calendar' do
        tags = []
        first = Date.new(year, month, 1)
        tags << '<tr>'.html_safe
        (Date.today.beginning_of_week..Date.today.end_of_week).each do |d|
          tags << %Q(<th class="border-none day">#{l(d, format: '%a')}</th>).html_safe
        end
        tags << '</tr>'.html_safe

        (first.beginning_of_month..first.end_of_month).each do |d|
          if d.monday?
            tags << '<tr>'.html_safe
          end

          if d == d.beginning_of_month && !d.monday?
            (d.cwday - 1).times { tags << '<td class="border-none"></td>'.html_safe }
          end

          tags << create_day(d, selected)

          if d.sunday?
            tags << '</tr>'.html_safe
          end

          if d == d.end_of_month
            (7 - d.cwday).times { tags << '<td class="border-none"></td>'.html_safe }
            tags << '</tr>'.html_safe
          end
        end
        month_name = case month
                 when 1
                   'ЯНВАРЬ'
                 when 2
                   'ФЕВРАЛЬ'
                 when 3
                   'МАРТ'
                 when 4
                   'АПРЕЛЬ'
                 when 5
                   'МАЙ'
                 when 6
                   'ИЮНЬ'
                 when 7
                   'ИЮЛЬ'
                 when 8
                   'АВГУСТ'
                 when 9
                   'СЕНТЯБРЬ'
                 when 10
                   'ОКТЯБРЬ'
                 when 11
                   'НОЯБРЬ'
                 when 12
                   'ДЕКАБРЬ'
               end
        tags.join.html_safe + "<h4 style='text-align: center;'><a href='#{actual_events_path(year: (first - 1.month).year, month: (first - 1.month).month, opened: 1)}'>&laquo;</a> #{month_name} #{first.year} <a href='#{actual_events_path(year: (first + 1.month).year, month: (first + 1.month).month, opened: 1)}'>&raquo;</a></h4>".html_safe
      end
    end
  end

  private

  def create_day(date, selected = nil)
    classes = %w(day border-none)
    classes << 'current' if date == Date.today
    if selected
      classes << 'success' if date == Date.parse(selected)
    end
    content_tag :td, class: classes.join(' '), data: { date: l(date) } do
      date.day.to_s
    end
  end

end