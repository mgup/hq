# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_date, class: 'Entrance::Date' do
    course 1
    start_date { Date.today }
    end_date { Date.today + 20.days }
    order_date { Date.today + 30.days }
    association :education_form
    association :education_type
    association :education_source
  end
end
