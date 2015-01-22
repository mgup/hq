# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :education_price do
    direction_id 1
    entrance_year 1
    course 1
    price "9.99"
  end
end
