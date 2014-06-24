require 'faker'

FactoryGirl.define do
  factory :entrance_exam, class: 'Entrance::Exam' do
    name      { Faker::Lorem.sentence }
    association :campaign

    trait :use do
      use 1
      association :use_subject
    end

    trait :not_use do
      use 0
    end
  end
end