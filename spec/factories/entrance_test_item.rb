require 'faker'

FactoryGirl.define do
  factory :entrance_test_item, class: 'Entrance::TestItem' do
    form      { Faker::Lorem.sentence }
    min_score { 40 + rand(60)}
    entrance_test_priority { 1+rand(3) }
    association :competitive_group
    association :exam, factory: :entrance_exam

    trait :use do
      association :use_subject
    end

    trait :not_use do
      subject_name { Faker::Lorem.sentence }
    end
  end
end