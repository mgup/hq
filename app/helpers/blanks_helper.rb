module BlanksHelper
  def blank_type(blank = @blank)
    type = Blank::TYPES.find { |t| t[1] == blank.type.to_i }
    type[0]
  end
end
