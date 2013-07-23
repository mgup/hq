module StudyHelper

  def pill_tabs(name, array, input, options = {})
    key = 1
    if !array.first.is_a?(Array)
      new = []
      array.each do |a|
        x = []
        x[0] = a
        x[1] = a
        new << x
      end
      key = 2
    end

    #if array.first.is_a?(Hash)
    #  new = []
    #  array.each do |a|
    #    x = a.to_a
    #    new << x
    #  end
    #  key = 2
    #end

    if options.key?(:class)
      options[:class] = options[:class] + ' nav nav-pills pill-select'
    end

    content_tag :ul, {class: 'nav nav-pills pill-select', name: "pill#{name}", id: "pill#{name}"}.merge(options) do
          tags = []
          (key==1 ? array : new).each do |item|
            li = content_tag(:li) {link_to item[1], '#', data: {toggle: 'pill', value: item[0], input: input} }
            tags << li
          end
        tags.join.html_safe
    end
  end

end