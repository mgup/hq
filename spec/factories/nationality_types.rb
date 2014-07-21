require 'faker'

FactoryGirl.define do
  factory :nationality_type do
    name { Faker::Lorem.word }
  end
end
