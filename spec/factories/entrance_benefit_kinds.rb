# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_benefit_kind, :class => 'Entrance::BenefitKind' do
    name "MyString"
  end
end
