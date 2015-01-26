require 'faker'

FactoryGirl.define do
  factory :entrance_status, class: 'Entrance::Status' do
    name { Faker::Lorem.word }
  end
end
