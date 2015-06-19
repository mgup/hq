require 'faker'

FactoryGirl.define do
  factory :purchase_good, class: Purchase::Good do
    name { Faker::Lorem.sentence }
    demand { Faker::Lorem.sentence }
  end
end
