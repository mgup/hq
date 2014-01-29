require 'faker'

FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    password { 'password' }

    association :fname, factory: :dictionary, strategy: :build
    association :iname, factory: :dictionary, strategy: :build
    association :oname, factory: :dictionary, strategy: :build

    trait :developer do
      after(:create) do |user|
        FactoryGirl.create :position,
                           role: FactoryGirl.create(:role, :developer),
                           user: user
      end
    end

    trait :lecturer do
      after(:create) do |user|
        FactoryGirl.create :position,
                           role: FactoryGirl.create(:role, :lecturer),
                           user: user
      end
    end
  end
end