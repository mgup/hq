require 'faker'

FactoryGirl.define do
  factory :entrance_application, class: 'Entrance::Application' do
    number { Faker::Lorem.sentence }
    registration_date { Date.today }
    last_deny_date { Date.today + 20.days }
    need_hostel false
    status_id 1
    comment { Faker::Lorem.paragraph }
    association :campaign
    association :competitive_group_item, strategy: :build
    association :entrant
    original false

    trait :original do
      original true
    end
  end
end
