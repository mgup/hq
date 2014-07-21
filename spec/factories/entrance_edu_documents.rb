require 'faker'

FactoryGirl.define do
  factory :edu_document, class: Entrance::EduDocument do
    number { 1000000 + rand(900000) }
    series { 1000 + rand(9000) }
    date { Date.today - (2+rand(4)).months }
    organization      { Faker::Lorem.sentence }
    graduation_year { Date.today.year - rand(3) }
    foreign_institution false
    our_institution false
    association :entrant
    association :entrance_document_type

    trait :mgup do
      our_institution true
    end
  end
end
