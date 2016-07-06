require 'faker'

FactoryGirl.define do
  factory :rigion, class: Rigion do
    kladr_id { 1 + rand(87)}
    pseries { 10 + rand(89)}
    name { Faker::Lorem.word }
  end
end
