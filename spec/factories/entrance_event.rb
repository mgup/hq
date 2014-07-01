require 'faker'

FactoryGirl.define do
  factory :entrance_event, class: 'Entrance::Event' do
    name  { Faker::Lorem.word }
    date { Date.today - (2+rand(6)).months - (2+rand(30)).days }
    association :campaign

    trait :with_entrants do
      callback(:after_build, :after_stub) do |event|
        4.times do
          event.event_entrants << build(:event_entrant, event: event)
        end
      end
    end
  end
end