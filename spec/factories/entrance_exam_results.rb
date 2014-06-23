
FactoryGirl.define do
  factory :exam_result, class: 'Entrance::ExamResult' do
    score { rand(100) }
    form 1
    association :entrant

    trait :empty do
      score nil
    end
  end
end
