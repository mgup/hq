# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_campaign, :class => 'Entrance::Campaign' do
    name "MyString"
    start_year 1
    end_year 1
    status 1
  end
end
