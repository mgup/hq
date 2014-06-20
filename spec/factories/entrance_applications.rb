# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_application, :class => 'Entrance::Application' do
    number "MyString"
    entrant_id 1
    registration_date "2014-06-19"
    last_deny_date "2014-06-19"
    need_hostel false
    status_id 1
    status_comment "MyText"
  end
end
