require 'faker'

FactoryGirl.define do
  factory :entrance_document_type, :class => 'Entrance::DocumentType' do
    name { Faker::Lorem.sentence }
  end
end
