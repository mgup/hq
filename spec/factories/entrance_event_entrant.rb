FactoryGirl.define do
  factory :event_entrant, class: 'Entrance::EventEntrant' do
    association :entrant
    association :event, factory: :entrance_event
  end
end