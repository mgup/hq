require 'faker'

FactoryGirl.define do
  factory :checkpoint, class: Study::Checkpoint do
    type { 1 + rand(1) }
    date 	{ Date.today }
    discipline
    factory :checkpoint_control do
      type { 3 }
      min { 11 }
      max { 20 }
      name { Faker::Lorem.word }
      details { Faker::Lorem.sentence }
    end
  end
end