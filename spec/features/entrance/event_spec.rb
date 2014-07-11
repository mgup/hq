require 'rails_helper'

feature 'Список участников вступительных испытаний' do
  background 'Любой человек' do
    user = create(:user, :selection)
    Thread.current[:user] = user
    @campaign = create(:campaign)
    @event = create(:entrance_event, :with_entrants, campaign: @campaign)
  end

  scenario 'Должен видеть список абитуриентов текущего мероприятия' do
    visit entrance_campaign_event_path(campaign_id: @campaign, id: @event)
    @event.entrants.each do |entrant|
      expect(page).to have_content(entrant.last_name)
    end
  end

  scenario 'Не должен видеть абитуриентов другого мероприятия' do
    other_event = create(:entrance_event, :with_entrants, campaign: @campaign)
    visit entrance_campaign_event_path(campaign_id: @campaign, id: @event)
    other_event.entrants.each do |entrant|
      expect(page).not_to have_content(entrant.last_name)
    end
  end

  scenario 'Может перейти к списку абитуриентов другого мероприятия', js: true, driver: :webkit do
    other_event = create(:entrance_event, :with_entrants, campaign: @campaign)
    visit entrance_campaign_event_path(campaign_id: @campaign, id: @event)
    select "#{other_event.name_with_date}", from: 'list_of_events'
    other_event.entrants.each do |entrant|
      expect(page).to have_content(entrant.last_name)
    end
  end

end