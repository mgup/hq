require 'faker'

FactoryGirl.define do
  factory :dictionary, class: Dictionary do
    ip { Faker::Lorem.word }
    rp { Faker::Lorem.word }
    dp { Faker::Lorem.word }
    vp { Faker::Lorem.word }
    tp { Faker::Lorem.word }
    pp { Faker::Lorem.word }
  end
end