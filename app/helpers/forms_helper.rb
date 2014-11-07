# Помощники вывода для создания элементов форм или других подобных элементов.
module FormsHelper
  # Создание списка для выбора элементов в виде кнопок (Bootstrap Pills).
  #
  # @param [Symbol] name Имя элемента ввода.
  # @param [Enumerable] container Список элементов для вывода. Каждый элемент
  #   должен отвечать на методы first и last. First становится значением
  #   элемента, а last — выводимой подписью.
  # @param selected Значение, выбранное по-умолчанию.
  def pills(name, container, selected = nil)
    capture do
      concat hidden_field_tag(name, selected)
      concat pills_items(name, container, selected)
    end
  end

  private

  def pills_items(name, container, selected = nil)
    content_tag(:ul, class: 'nav nav-pills pill-select') do
      container.each do |item|
        value, text = pills_item_value_and_text(item)
        link = link_to(text, '#',
                       data: { toggle: 'pill', value: value, input: name })

        opts = {}
        opts &&= { class: 'active' } if value == selected

        concat content_tag(:li, link, opts)
      end
    end
  end

  def pills_item_value_and_text(item)
    if item.respond_to?(:first) && item.respond_to?(:last)
      return item.first, item.last
    else
      return item, item
    end
  end
end
