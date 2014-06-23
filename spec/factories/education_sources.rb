require 'faker'

FactoryGirl.define do
  factory :education_source do
    name { Faker::Lorem.sentence }
  end
end
