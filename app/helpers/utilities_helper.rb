module UtilitiesHelper
  def prettify(num)
    num.to_i == num ? num.to_i : num
  end
end