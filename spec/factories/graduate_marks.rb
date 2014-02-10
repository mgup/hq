# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :graduate_mark do
    graduate_student_id 1
    graduate_subject_id 1
    mark "MyString"
  end
end
