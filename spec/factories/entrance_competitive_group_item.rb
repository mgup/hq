require 'faker'

FactoryGirl.define do
  factory :competitive_group_item, class: Entrance::CompetitiveGroupItem do
    number_budget_o 0
    number_budget_oz 0
    number_budget_z 0
    number_paid_o 0
    number_paid_oz 0
    number_paid_z 0
    number_quota_o 0
    number_quota_oz 0
    number_quota_z 0
    association :competitive_group
    association :education_type
    association :direction

    trait :budget_o do
      number_budget_o {1+rand(20)}
    end

    trait :budget_oz do
      number_budget_oz {1+rand(20)}
    end

    trait :budget_z do
      number_budget_z {1+rand(20)}
    end

    trait :paid_o do
      number_paid_o {1+rand(20)}
    end

    trait :paid_oz do
      number_paid_oz {1+rand(20)}
    end

    trait :paid_z do
      number_paid_z {1+rand(20)}
    end
  end
end
