# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :use_subject, :class => 'Use::Subject' do
    name "MyString"
  end
end
