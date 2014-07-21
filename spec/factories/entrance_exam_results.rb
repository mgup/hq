
FactoryGirl.define do
  factory :exam_result, class: 'Entrance::ExamResult' do
    score { rand(100) }
    form 1
    association :entrant
    association :exam, factory: :entrance_exam

    trait :empty do
      score nil
    end
  end
end
