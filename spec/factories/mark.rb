require 'faker'

FactoryGirl.define do
  factory :mark, class: Study::Mark do
    checkpoint
    student
    checkpoint_mark_submitted { DateTime.now }

    factory :lecture_mark do
      mark { 1001 + rand(1) }
    end

    factory :practical_mark do
      mark { 2001 + rand(1) }
    end

    factory :checkpoint_mark do
      mark { rand(20) }
    end
  end
end