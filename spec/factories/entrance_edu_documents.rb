# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entrance_edu_document, :class => 'Entrance::EduDocument' do
    document_type_id 1
    series "MyString"
    number "MyString"
    date "2014-06-25"
    organization "MyString"
    graduation_year 1
    gpa 1.5
    registration_number "MyString"
    qualification_type_id 1
    speciality_id 1
    specialization_id 1
    profession_id 1
    document_type_name_text "MyString"
  end
end
