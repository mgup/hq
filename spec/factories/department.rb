require 'faker'

FactoryGirl.define do
  factory :department, class: Department do
    name         { Faker::Lorem.sentence }
    abbreviation { Faker::Lorem.word }
  end
end