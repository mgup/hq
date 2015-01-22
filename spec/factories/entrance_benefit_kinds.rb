require 'faker'

FactoryGirl.define do
  factory :entrance_benefit_kind, class: 'Entrance::BenefitKind' do
    name { Faker::Lorem.sentence }
  end
end
