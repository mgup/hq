require 'faker'

FactoryGirl.define do
  factory :role, class: Role do
    name        { Faker::Lorem.word }
    title       { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    trait :developer do
      name 'developer'
    end

    trait :lecturer do
      name 'lecturer'
    end
  end
end