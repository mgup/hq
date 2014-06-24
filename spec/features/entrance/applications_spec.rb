require 'spec_helper'

feature 'Список заявлений абитуриента' do
  background 'Сотрудник приёмной комисии' do
    @campaign =  create(:campaign)
    @application = create(:entrance_application, campaign: @campaign, entrant: create(:entrant, campaign: @campaign))
    @entrant = @application.entrant
    as_user(create(:user, :selection))
  end

  scenario 'Должен видеть список заявлений абитуриента' do
    visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
    expect(page).to have_content(@application.number)
  end

  scenario 'Не должен видеть заявления других абитуриентов' do
    other_application = create(:entrance_application, campaign: @campaign, entrant: create(:entrant, campaign: @campaign))
    visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
    expect(page).not_to have_content(other_application.number)
  end

  scenario 'Может распечатать все заявления абитуриента' do
    visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
    click_link 'Распечатать все заявления'
    #   Хм...
  end

  scenario 'Может распечатать отдельное заявление абитуриента' do
    visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
    click_link 'Распечатать заявление'
    #   Хм...
  end

end