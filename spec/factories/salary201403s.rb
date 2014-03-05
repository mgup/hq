# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :salary201403 do
    faculty_id 1
    department_id 1
    user_id 1
    untouchable false
    has_report false
    credits "9.99"
    previous_premium "9.99"
    new_premium "9.99"
  end
end
