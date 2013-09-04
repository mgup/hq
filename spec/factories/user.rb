require 'faker'

FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    password ::Digest::MD5.hexdigest('password')

    trait :lecturer do
      after(:create) do |user|
        FactoryGirl.create :position,
                           role: FactoryGirl.create(:role, :lecturer),
                           user: user
      end
    end

    factory :developer do
      after(:create) do |user, evaluator|
        FactoryGirl.create :position_developer, user: user
      end
    end
  end
end