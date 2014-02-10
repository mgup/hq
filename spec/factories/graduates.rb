# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :graduate do
    speciality_id 1
    year 1
    chairman "MyString"
    secretary "MyString"
  end
end
