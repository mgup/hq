require 'faker'

FactoryGirl.define do
  factory :education_type do
    name { Faker::Lorem.sentence }
  end
end
