require 'faker'

FactoryGirl.define do
  factory :education_form do
    name { Faker::Lorem.sentence }
  end
end
