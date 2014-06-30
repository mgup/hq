# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_document_movement, :class => 'Entrance::DocumentMovement' do
    moved false
    original false
    from_application_id 1
    to_application_id 1
  end
end
