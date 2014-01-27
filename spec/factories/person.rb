require 'faker'

FactoryGirl.define do
  factory :person, class: Person do
    passport_series { 0000 }
    passport_number { 000000 }
    passport_date   { Date.today }
    passport_department { Faker::Lorem.sentence }
    passport_department_code { 00-00 }
    student_status { 100 + rand(3) }
    student_oldid { rand(10) }
    student_oldperson { rand(10) }
    association :fname, factory: :dictionary, strategy: :build
    association :iname, factory: :dictionary, strategy: :build
    association :oname, factory: :dictionary, strategy: :build
  end
end