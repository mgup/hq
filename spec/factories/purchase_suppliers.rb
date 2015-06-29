require 'faker'

FactoryGirl.define do
  factory :purchase_supplier, class: Purchase::Supplier do
    name { Faker::Name.name }
    inn { Faker::Number.number(10) }
    address { Faker::Address.street_address }
  end
end
