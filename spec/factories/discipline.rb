require 'faker'

FactoryGirl.define do
  factory :discipline, class: Study::Discipline do
    name        { Faker::Lorem.sentence }
    semester 	{ 1 }
    year		{ Date.today.strftime("%Y") }
    subject_group		{ FactoryGirl.create(:group).id }
    subject_teacher	{ FactoryGirl.create(:user).id }
    factory :discipline_with_checkpoints, parent: :discipline do
      after(:build) do |discipline|
        discipline.checkpoints << FactoryGirl.build(:checkpoint, checkpoint_subject: discipline)
      end
    end
    factory :discipline_with_controls, parent: :discipline do
      after(:build) do |discipline|
        4.times do
          discipline.checkpoints << FactoryGirl.build(:checkpoint_control, checkpoint_subject: discipline)
        end
      end
    end
  end
end