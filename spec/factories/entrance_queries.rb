require 'faker'

FactoryGirl.define do
  factory :entrance_query do
    request { Faker::Lorem.sentence }
    response { Faker::Lorem.sentence }
  end
end
