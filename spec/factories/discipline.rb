require 'faker'

FactoryGirl.define do
  factory :discipline, class: Study::Discipline do
    name        { Faker::Lorem.sentence }
    semester 	{ 1 }
    year		{ Date.today.strftime("%Y") }
    group		{ Group.first }
    lead_techer	{ User.first }
    final_exams { FactoryGirl.create(:final_exam) }
  end
end