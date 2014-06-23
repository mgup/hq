# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_log, :class => 'Entrance::Log' do
    user_id 1
    entrant_id 1
    comment "MyString"
  end
end
