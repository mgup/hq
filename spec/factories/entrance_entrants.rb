require 'faker'

FactoryGirl.define do
  factory :entrant, class: 'Entrance::Entrant' do
    last_name  { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    patronym { Faker::Lorem.word }
    gender { [:male, :female].sample }
    information { Faker::Lorem.sentence }
    birthday { Date.today - 18.years }
    birth_place { Faker::Lorem.sentence }
    pseries { 1000 + rand(9000) }
    pnumber { 100000 + rand(900000) }
    pdepartment { Faker::Lorem.sentence }
    pdate { Date.today - 4.years }
    azip { 100000 + rand(900000) }
    aaddress { Faker::Lorem.sentence }
    institution { Faker::Lorem.sentence }
    graduation_year { Date.today.year }
    certificate_number { 123 + rand(2000) }
    certificate_date { Date.today - 2.months }
    need_hostel_for_exams false
    phone '+7 900 123-45-67'
    military_service { [:not, :conscript, :reservist, :free_of_service, :too_young].sample }
    association :campaign
    association :identity_document_type
    association :nationality_type

    trait :with_exams do
      callback(:after_build, :after_stub) do |entrant|
        3.times do
          entrant.exam_results << build(:exam_result, entrant: entrant)
        end
      end
    end
  end
end
