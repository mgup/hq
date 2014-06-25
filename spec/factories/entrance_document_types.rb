# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_document_type, :class => 'Entrance::DocumentType' do
    name "MyString"
  end
end
