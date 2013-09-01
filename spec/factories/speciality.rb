alias_attribute :code,    :speciality_code
  alias_attribute :name,    :speciality_name
  alias_attribute :type,    :speciality_ntype
  alias_attribute :suffix,  :speciality_short_name
require 'faker'

FactoryGirl.define do
  factory :speciality, class: Speciality do
  	name { Faker::Lorem.sentence }
  	type { rand(2) }
  	suffix { Faker::Lorem.word }
    department	{ FactoryGirl.create :department }
  end
end