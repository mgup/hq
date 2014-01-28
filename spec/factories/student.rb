require 'faker'

FactoryGirl.define do
  factory :student, class: Student do
    association :person, factory: :person, strategy: :build
    association :group, factory: :group, strategy: :build
    student_group_oldstudent { 0 }
    student_group_oldgroup { 0 }
    student_group_status { 101 }
  end
end