require 'faker'

FactoryGirl.define do
  factory :user, class: User do
    username { Faker::Internet.user_name }
    password ::Digest::MD5.hexdigest('password')

    factory :developer do
      after(:create) do |user, evaluator|
        FactoryGirl.create :position_developer, user: user
      end
    end
  end
end