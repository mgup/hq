require 'faker'

FactoryGirl.define do
  factory :campaign, class: Entrance::Campaign do
    start_year		  { Study::Discipline::CURRENT_STUDY_YEAR + 1 }
    end_year		  { Study::Discipline::CURRENT_STUDY_YEAR + 1 }
    name      { Faker::Lorem.sentence }
    status 0
  end
end