require 'faker'

FactoryGirl.define do
  factory :speciality, class: Speciality do
  	name { Faker::Lorem.sentence }
  	type { rand(2) }
  	suffix { Faker::Lorem.word }
    speciality_faculty	{ FactoryGirl.create :department }
  end
end