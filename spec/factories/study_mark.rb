require 'faker'

FactoryGirl.define do
  factory :mark, class: Study::Mark do
    checkpoint
    student
    checkpoint_mark_submitted { DateTime.now }

    trait :lecture do
      mark { 1001 + rand(1) }
    end

    trait :practical do
      mark { 2001 + rand(1) }
    end

    trait :checkpoint do
      mark { rand(80) }
    end
  end
end