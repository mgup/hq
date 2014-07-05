# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_contract, :class => 'Entrance::Contract' do
    number "MyString"
    application_id 1
  end
end
