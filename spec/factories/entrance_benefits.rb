# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_benefit, :class => 'Entrance::Benefit' do
    application_id 1
    benefit_kind_id 1
    document_type_id 1
    temp_text "MyString"
  end
end
