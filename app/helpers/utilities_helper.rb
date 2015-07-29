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

  def pluralize_without_number(n, f1, f2, f5)
    "#{Russian::pluralize(n, f1, f2, f5)}"
  end

  def embed_pdf(path)
    content_tag(:object,
                data: path,
                type: 'application/pdf',
                width: '100%',
                height: '600') do
      content_tag(:p) do
        'Ваш браузер не поддерживает просмотр PDF документов'
      end
    end
  end
end
