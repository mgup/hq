require 'faker'

FactoryGirl.define do
  factory :discipline, class: Study::Discipline do
    name        { Faker::Lorem.sentence }
    semester 	{ 1 }
    year		{ Date.today.strftime("%Y") }
    group		{ Group.first }
    subject_teacher	{ User.first }
  end
end