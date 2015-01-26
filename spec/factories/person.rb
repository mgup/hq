require 'faker'

FactoryGirl.define do
  factory :person, class: Person do
    student_status { 100 + rand(3) }
    student_oldid { rand(10) }
    student_oldperson { rand(10) }
    association :fname, factory: :dictionary, strategy: :build
    association :iname, factory: :dictionary, strategy: :build
    association :oname, factory: :dictionary, strategy: :build
  end
end
