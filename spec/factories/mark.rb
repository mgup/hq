require 'faker'

FactoryGirl.define do
  factory :mark, class: Study::Mark do
    checkpoint
    student
    checkpoint_mark_submitted { DateTime.now }

    trait :lecture_mark do
      mark { 1001 + rand(1) }
    end

    trait :practical_mark do
      mark { 2001 + rand(1) }
    end

    trait :checkpoint_mark do
      mark { rand(80) }
    end
  end
end