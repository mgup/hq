require 'faker'

FactoryGirl.define do
  factory :discipline, class: Study::Discipline do
    name        { Faker::Lorem.sentence }
    semester 	{ 1 }
    year		{ Date.today.strftime("%Y") }
    group		{ FactoryGirl.create :group }
    subject_teacher	{ FactoryGirl.create :user }
  end
end