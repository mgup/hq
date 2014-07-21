require 'faker'

FactoryGirl.define do
  factory :appointment, class: Appointment do
    title       { Faker::Lorem.word }
  end
end