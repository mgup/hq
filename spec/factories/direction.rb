require 'faker'

FactoryGirl.define do
  factory :direction, class: Direction do
    name { Faker::Lorem.sentence }
    code { 100000 + rand(900000)}
    new_code { "#{rand(99)}.#{rand(99)}.#{rand(99)}.#{rand(99)}"}
    qualification_code { [62,65,68].sample }
    ugs_code { '00.00.00' }
    ugs_name { Faker::Lorem.sentence }
    letters { Faker::Lorem.word }
    association :department
  end
end