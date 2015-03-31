require 'faker'

FactoryGirl.define do
  factory :discipline, class: Study::Discipline do
    subject_year		  { Study::Discipline::CURRENT_STUDY_YEAR }
    subject_semester  { Study::Discipline::CURRENT_STUDY_TERM }
    subject_name      { Faker::Lorem.sentence }
    subject_brs { true }
    association :group
    association :lead_teacher, factory: [:user, :lecturer]
  end
end
