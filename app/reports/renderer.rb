class Renderer
  attr_reader :result

  def render(&block)
    block.call(self)

    @result
  end

  def title
    fail 'Отсутствует реализация вывода заголовка отчёта.'
  end

  def text
    fail 'Отсутствует реализация вывода тексотовой информации.'
  end

  def image
    fail 'Отсутствует реализация вывода изображений.'
  end
end