module Study::CheckpointmarkHelper

  def circle_tips(circle_title, color, size, padding_left, text, options = {})

    if options.key?(:class)
      options[:class] = options[:class] + ' pull-left'
    end

    content_tag :div, {class: 'pull-left', title: "#{circle_title}", style: "
              border-radius: 50%;
              background-color: #{color};
              width: #{size}px; height: #{size}px;
              border: 1px solid black;
              margin-right: 10px;
              padding: 4px 0 0 #{padding_left}px;
              margin-top: 5px;" }.merge(options) do

      content_tag :strong do
        text
      end
    end
  end

end