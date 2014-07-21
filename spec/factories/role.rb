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

    trait :selection do
      name 'selection'
    end
  end
end
