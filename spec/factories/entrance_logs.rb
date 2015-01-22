require 'faker'

FactoryGirl.define do
  factory :entrance_log, class: 'Entrance::Log' do
    comment { Faker::Lorem.sentence }
    association :user
    association :entrant
  end
end
