module ActivityHelper
  def activity_credit_description(a = @activity)
    credit = number_with_precision(prettify(a.credit), precision: 1, strip_insignificant_zeros: true)
    txt = Russian::p(prettify(a.credit.abs), 'балл', 'балла', 'баллов', 'балла')

    case a.activity_credit_type_id.to_i
      when 1
        "#{credit} #{txt}"
      when 2
        "#{credit} #{txt} #{a.base_name}"
      when 3
        "От 0 до #{credit} #{txt}"
      else
        raise 'Неизвестный тип баллов показателя эффективности'
    end
  end

  private

  def prettify(num)
    num.to_i == num ? num.to_i : num
  end
end