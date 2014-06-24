require 'faker'

FactoryGirl.define do
  factory :direction, class: Direction do
    name { Faker::Lorem.sentence }
    code { '111111' }
    qualification_code { [62,65,68].sample }
    ugs_code { '00.00.00' }
    ugs_name { Faker::Lorem.sentence }
  end
end