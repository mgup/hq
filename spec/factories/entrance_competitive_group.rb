require 'faker'

FactoryGirl.define do
  factory :competitive_group, class: Entrance::CompetitiveGroup do
    course 1
    name      { Faker::Lorem.sentence }
    association :campaign

    callback(:after_build, :after_stub) do |competitive_group|
      5.times do
        competitive_group.items << build(:competitive_group_item, competitive_group: competitive_group)
      end
    end
  end
end