# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_entrant, :class => 'Entrance::Entrant' do
    last_name "MyString"
    first_name "MyString"
    patronym "MyString"
    gender 1
    snils "MyString"
    information "MyString"
  end
end
