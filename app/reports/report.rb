class Report
  include ActiveSupport::NumberHelper

  attr_accessor :renderer

  def render(format: :pdf)
    @renderer = eval("Renderers::#{format.to_s.capitalize}Renderer").new
    _render
  end

  def _render
    fail 'Отсутствует реализация алгоритма формирования отчёта.'
  end

  protected

  def parse_image(image, format: :data_url)
    case format
      when :io
        StringIO.new(image)
      when :data_url

      else
        fail 'Неизвестный формат вывода изображения.'
    end
  end
end