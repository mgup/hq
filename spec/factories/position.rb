require 'faker'

FactoryGirl.define do
  factory :position, class: Position do
    title       { Faker::Lorem.word }
    appointment

    user
    role
    association :department, factory: [:department, :academic], strategy: :build

    factory :position_developer do
      association :role, factory: :role_developer
    end
  end
end