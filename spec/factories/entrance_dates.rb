# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_date, :class => 'Entrance::Date' do
    course 1
    start_date "2014-06-16"
    end_date "2014-06-16"
    order_date "2014-06-16"
    education_form_id 1
    education_level_id 1
    education_source_id 1
  end
end
