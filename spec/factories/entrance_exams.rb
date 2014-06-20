# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_exam, :class => 'Entrance::Exam' do
    campaign_id 1
    use false
    pass_mark 1
    name "MyString"
  end
end
