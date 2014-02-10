# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :graduate_student do
    graduate_id 1
    student_id 1
    thesis "MyString"
    mark 1
    registration "MyString"
    education "MyString"
  end
end
