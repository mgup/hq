require 'faker'

FactoryGirl.define do
  factory :position, class: Position do
    title       { Faker::Lorem.word }
    appointment { Date.today }

    user
    role
    department

    factory :position_developer do
      association :role, factory: :role_developer
    end
  end
end