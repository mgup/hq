module Study::MarkHelper
  def mark_count(ball, result = nil, reason = nil)
    if reason
      case reason
      when '1'
        { ball: 0, mark: 'неявка', value: Study::ExamMark::VALUE_NEYAVKA, span: 'danger'}
      when '9'
        { ball: 0, mark: 'недопущен', value: Study::ExamMark::VALUE_NEDOPUSCHEN, span: 'danger' }
      end
    elsif ball.to_i < 55
      { ball: ball, mark: 'неудовлетворительно', value: Study::ExamMark::VALUE_2, span: 'danger' }
    else
      case result.floor
      when 85..100
        { ball: ball, mark: 'отлично', value: Study::ExamMark::VALUE_5, span: 'success' }
      when 70..84
        { ball: ball, mark: 'хорошо', value: Study::ExamMark::VALUE_4, span: 'info' }
      when 55..69
        { ball: ball, mark: 'удовлетворительно', value: Study::ExamMark::VALUE_3, span: 'warning' }
      else { ball: ball, mark: 'неудовлетворительно', value: Study::ExamMark::VALUE_2, span: 'danger' }
      end
    end
  end
end