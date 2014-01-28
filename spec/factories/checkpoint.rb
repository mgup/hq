require 'faker'

FactoryGirl.define do
  factory :checkpoint, class: Study::Checkpoint do
    type { 1 + rand(1) }
    date 	{ Date.today }
    discipline
    trait :checkpoint_control do
      type { 3 }
      min { 44 }
      max { 80 }
      name { Faker::Lorem.word }
      details { Faker::Lorem.sentence }
    end
  end
end