require 'faker'

FactoryGirl.define do
  factory :competitive_group, class: Entrance::CompetitiveGroup do
    course 1
    name      { Faker::Lorem.sentence }
    association :campaign
  end
end