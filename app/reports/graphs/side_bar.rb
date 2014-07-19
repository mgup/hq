module Graphs
  # Заготовка графика с «горизонтальными» колонками.
  class SideBar < Gruff::SideBar
    def initialize(target_width)
      super(target_width)

      self.theme = { colors: %w(#aaaaaa),
                     marker_color: '#aea9a9',
                     font_color: 'black',
                     background_colors: 'white' }
    end

    def initialize_ivars
      super

      @maximum_value = @minimum_value = 0

      @font = ::Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf').to_s

      @marker_font_size = 20

      @top_margin = @bottom_margin = @left_margin = @right_margin = 0

      @hide_legend = @hide_line_numbers = true
    end

    def to_png
      to_blob('PNG')
    end
  end
end
