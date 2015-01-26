module StudyHelper
  def pill_tabs(name, array, input, options = {})
    key = 1
    unless array.first.is_a?(Array)
      new = []
      array.each do |a|
        x = []
        x[0] = a
        x[1] = a
        new << x
      end
      key = 2
    end

    if options.key?(:class)
      options[:class] = options[:class] + ' nav nav-pills pill-select'
    end

    content_tag :ul, { class: 'nav nav-pills pill-select', name: "pill#{name}",
                       id: "pill#{name}" }.merge(options) do
      tags = []
      (key == 1 ? array : new).each do |item|
        tags << content_tag(:li) do
          link_to item[1], '#',
                  data: { toggle: 'pill', value: item[0], input: input }
        end
      end
      tags.join.html_safe
    end
  end

  def study_form_name(form, p = :ip)
    t "form.#{form}.#{p}"
  end
end
