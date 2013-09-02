require 'faker'

FactoryGirl.define do
  factory :discipline, class: Study::Discipline do
    name        { Faker::Lorem.sentence }
    semester 	{ 1 }
    year		{ Date.today.strftime("%Y") }
    subject_group		{ FactoryGirl.create(:group).id }
    subject_teacher	{ FactoryGirl.create(:user).id }
  end
end