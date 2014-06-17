# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_query do
    request "MyText"
    response "MyText"
  end
end
