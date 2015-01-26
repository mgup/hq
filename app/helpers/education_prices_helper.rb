module EducationPricesHelper
  def education_prices_by_course(direction_id, form, prices)
    needed = prices.find_all do |p|
      p.direction_id == direction_id && p.education_form_id == form
    end

    needed.sort_by { |n| n.course }
  end

  def education_price_total(direction_id, form, prices)
    s = education_prices_by_course(direction_id, form, prices).inject(0) do |r, p|
      r + p.price
    end

    s.zero? ? nil : s
  end
end