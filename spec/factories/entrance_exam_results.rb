# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_exam_result, :class => 'Entrance::ExamResult' do
    entrant_id 1
    exam_id 1
    score 1
    type 1
    document "MyString"
  end
end
