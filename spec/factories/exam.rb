
FactoryGirl.define do
  factory :exam, class: Study::Exam do
   type     { 1 + rand(5) }
   date     { Date.today }
   weight   { rand(100) }

   discipline
  	factory :final_exam do
      type     { 1 + rand(2) }
  	end
  end
end