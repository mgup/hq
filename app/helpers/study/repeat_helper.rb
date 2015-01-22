module Study::RepeatHelper
  def repeat_type(repeat = @repeat)
    Study::Repeat::TYPE_OPTIONS.find { |t| t[1] == repeat.type }[0]
  end
end
