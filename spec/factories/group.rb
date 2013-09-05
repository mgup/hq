require 'faker'

FactoryGirl.define do
   factory :group, class: Group do
    group_name     { Faker::Lorem.word }
   	course         { 1 + rand(4) }
    group_ncourse  { 1 + rand(4) }
    group_semester {  1 + rand(11) }
   	number         { 1 + rand(2) }
   	form           { 101 + rand(3) }
    speciality
   end
end