require 'faker'

FactoryGirl.define do
  factory :campaign, class: 'Entrance::Campaign' do
    start_year { Study::Discipline::CURRENT_STUDY_YEAR + 1 }
    end_year	 { Study::Discipline::CURRENT_STUDY_YEAR + 1 }
    name       { Faker::Lorem.sentence }
    status 0

    callback(:after_build, :after_stub) do |campaign|
      5.times do
        campaign.competitive_groups << build(:competitive_group, campaign: campaign)
      end
    end
  end
end