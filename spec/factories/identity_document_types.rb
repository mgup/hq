require 'faker'

FactoryGirl.define do
  factory :identity_document_type do
    name { Faker::Lorem.word }
  end
end
