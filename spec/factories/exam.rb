
FactoryGirl.define do
  factory :exam, class: Study::Exam do
    type     { 1 + rand(5) }
    date     { Date.today }
    weight   { 50 }

    trait :final do
      type   { [Study::Exam::TYPE_TEST, Study::Exam::TYPE_GRADED_TEST, Study::Exam::TYPE_EXAMINATION][rand(2)] }
    end

   #discipline
  	#factory :final_exam do
   #   type     { 1 + rand(2) }
  	#end


  end
end