# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_status, :class => 'Entrance::Status' do
    name "MyString"
  end
end
