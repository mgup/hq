require 'faker'

FactoryGirl.define do
  factory :department, class: Department do
    name         { Faker::Lorem.sentence }
    abbreviation { Faker::Lorem.word }

  trait :academic do
    department_role { 'subdepartment' }
  end
  end
end