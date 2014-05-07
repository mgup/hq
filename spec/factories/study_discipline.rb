require 'faker'

FactoryGirl.define do
  factory :discipline, class: Study::Discipline do
    subject_year		  { Study::Discipline::CURRENT_STUDY_YEAR }
    subject_semester  { 1 + rand(1) }
    subject_name      { Faker::Lorem.sentence }
    subject_brs { true }
    association :group
    association :lead_teacher, factory: [:user, :lecturer]

    # before(:create) do |discipline|
    #   # raise discipline.final_exam.inspect
    #   discipline.final_exam = create(:exam, :final) if discipline.final_exam.nil?
    # end

    # association :final_exam,   factory: [:exam, :final]

    # after(:create) do |discipline|
    #   discipline.final_exam = FactoryGirl.create(:final_exam, exam_subject: discipline)
    # end
    #
    #factory :discipline_with_checkpoints, parent: :study_discipline do
    #  after(:build) do |discipline|
    #    discipline.checkpoints << FactoryGirl.build(:checkpoint, checkpoint_subject: discipline)
    #  end
    #end
    #
    #trait :discipline_with_controls do
    #  after(:build) do |discipline|
    #    4.times do
    #      discipline.checkpoints << FactoryGirl.build(:checkpoint_control, checkpoint_subject: discipline)
    #    end
    #  end
    #end
  end
end