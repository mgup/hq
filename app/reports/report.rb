# Базовый класс для создания отчётов, которые могут выводиться
# в разных форматах (HTML, PDF).
class Report
  include ActiveSupport::NumberHelper

  attr_accessor :renderer

  def render(format: :pdf)
    @renderer = Object.const_get(
      "Renderers::#{format.to_s.capitalize}Renderer"
    ).new

    @renderer.render { _render }
  end

  def _render
    fail 'Отсутствует реализация алгоритма формирования отчёта.'
  end
end
