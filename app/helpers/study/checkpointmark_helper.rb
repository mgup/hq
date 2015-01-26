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

  def mark_progress(ball, progress, type = nil)
    if type == Study::Exam::TYPE_TEST
      case progress.round
      when 0..54
        { ball: ball, progress: progress, mark: 'не зачтено', short: 'незачёт', color: 'danger' }
      when 55..100
        { ball: ball, progress: progress, mark: 'зачтено', short: 'зачёт', color: 'success' }
      end
    else
      case progress.round
        when 0..54
          {ball: ball, progress: progress, mark: 'недопущен', short: 'недопущен', color: 'danger'}
        when  55..69
          {ball: ball, progress: progress, mark: 'удовлетворительно', short: 'удовл.', color: 'warning'}
        when 70..85
          {ball: ball, progress: progress, mark: 'хорошо', short: 'хорошо', color: 'info'}
        when 86..100
          {ball: ball, progress: progress, mark: 'отлично', short: 'отлично', color: 'success'}
      end
    end
  end

end