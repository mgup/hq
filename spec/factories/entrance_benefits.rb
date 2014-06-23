require 'faker'

FactoryGirl.define do
  factory :entrance_benefit, class: 'Entrance::Benefit' do
    association :entrance_application
    association :entrance_benefit_kind
    document_type_id 1
    temp_text { Faker::Lorem.sentence }
  end
end
