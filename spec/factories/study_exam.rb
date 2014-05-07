
FactoryGirl.define do
  factory :exam, class: Study::Exam do
    type     { 1 + rand(5) }
    date     { Date.today }
    weight   { 50 }

    association :discipline

    trait :final do
      type   { [Study::Exam::TYPE_TEST, Study::Exam::TYPE_GRADED_TEST, Study::Exam::TYPE_EXAMINATION][rand(2)] }
    end

    trait :work do
      type   { Study::Exam::TYPE_SEMESTER_WORK }
    end

    trait :project do
      type   { Study::Exam::TYPE_SEMESTER_PROJECT }
    end
  end
end