require 'faker'

FactoryGirl.define do
  factory :user, class: User do
    username { Faker::Internet.user_name }
    password ::Digest::MD5.hexdigest('password')
  end
end