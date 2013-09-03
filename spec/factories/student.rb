require 'faker'

FactoryGirl.define do
  factory :student, class: Student do
    person
    group
    student_group_oldstudent { 0 }
    student_group_oldgroup { 0 }
  end
end