require 'faker'

FactoryGirl.define do
   factory :speciality, class: Speciality do
   	name { Faker::Lorem.sentence }
    speciality_code { '111111' }
   	type { rand(2) }
   	suffix { 'xxx' }
    speciality_shortname { 'xx' }
    speciality_olength { 0 }
    speciality_zlength { 0 }
    speciality_ozlength { 0 }
    association :faculty, factory: :department, strategy: :build
   end
end