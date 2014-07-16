# Хэлперы, которые не относятся ни к каким отдельным модулям системы.
module UtilitiesHelper
  # Обработка знаков после запятой. Если дробное число не имеет знаков после
  # запятой, то оно выводится без запятой с нулями.
  def prettify(num)
    num.to_i == num ? num.to_i : num
  end

  def pluralize(n, f1, f2, f5)
    "#{n} #{Russian::pluralize(n, f1, f2, f5)}"
  end
end
