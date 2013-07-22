module StudyHelper

  def pill_tabs(name, array, input)
    key = 1
    if !array.first.is_a?(Hash)
      new = []
      array.each do |a|
        new << {name: a, value: a}
      end
      key = 2
    end

    content_tag :ul, {class: 'nav nav-pills pill-select', name: "pill#{name}", id: "pill#{name}"} do
          tags = []
          (key==1 ? array : new).each do |item|
            li = content_tag(:li) {link_to item[:name], '#', data: {toggle: 'pill', value: item[:value], input: input} }
            tags << li
          end
        tags.join.html_safe
    end
  end

end