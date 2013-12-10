module MultiselectHelper
  def multiselect_tag(name, opts = {})
    opts[:marker] ||= '%c'
    opts[:pl1]    ||= "Выбран #{opts[:marker]} пункт"
    opts[:pl2]    ||= "Выбраны #{opts[:marker]} пункта"
    opts[:pl5]    ||= "Выбрано #{opts[:marker]} пунктов"

    title = opts[:title]

    count = opts[:current].length
    if count > 0
      title = Russian::pluralize(count, opts[:pl1], opts[:pl2], opts[:pl5]).sub(opts[:marker], count.to_s)
    end

    content_tag(:div, class: 'multiselect btn-group') do
      tags = []
      tags << content_tag(:button, class: 'btn btn-default dropdown-toggle form-control', data: { toggle: 'dropdown' }) do
        %Q(#{title} <span class="caret"></span>).html_safe
      end

      tags << content_tag(:ul, opts[:collection] ? options_from_collection(name, opts) : raise('Нужно реализовать') ,class: 'dropdown-menu')

      tags.join.html_safe
    end
  end

  private

  def options_from_collection(name, opts)
    tags = []

    opts[:collection].each do |i|
      tags << content_tag(:li) do
        value = i.send(opts[:value])

        link_to '#' do
          [
              check_box_tag("#{name}[]", value, opts[:current].include?(value)),
              i.send(opts[:text])
          ].join.html_safe
        end
      end
    end

    tags.join.html_safe
  end
end