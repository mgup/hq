require 'faker'

FactoryGirl.define do
  factory :role, class: Role do
    name        { Faker::Lorem.word }
    title       { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    factory :role_developer do
      name 'developer'
    end
  end
end