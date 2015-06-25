require 'faker'

FactoryGirl.define do
  factory :purchase_line_item, class: Purchase::LineItem do
    purchase_id { Faker::Number.number(4) }
    good_id { Faker::Number.number(4) }
    measure 'час'
    start_price { Faker::Commerce.price }
    total_price { Faker::Commerce.price }
    period '12 мес'
    p_start_date { Faker::Date.forward }
    p_end_date { Faker::Date.forward }
    supplier_id { Faker::Number.number(4) }
    published 'не_о'
    contracted 'не_з'
    delivered 'не_п'
    paid 'не_оп'
  end
end
