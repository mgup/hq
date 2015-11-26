require 'faker'

FactoryGirl.define do
  factory :purchase_purchase, class: Purchase::Purchase do
    dep_id { Faker::Number.number(4) }
    number { Faker::Number.number(5) }
  end
end
