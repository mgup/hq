require 'rails_helper'

feature 'Список вступительных испытаний абитуриента' do
  background 'Сотрудник приёмной комиссии' do
    user = create(:user, :selection)
    Thread.current[:user] = user
    as_user(user)
    @entrant = create(:entrant)
    @campaign = @entrant.campaign
  end

  scenario 'Может перейти на страницу со вступительными испытаниями со страницы с абитуриентами' do
    visit entrance_campaign_entrants_path(campaign_id: @campaign)
    first('.btn-info').click
    expect(page).to have_content('Мероприятия с абитуриентом')
    expect(page).to have_content(@entrant.full_name)
  end

  scenario 'Должен видеть мероприятия, на которые записан абитуриент' do
    event = create(:entrance_event)
    create(:event_entrant, event: event, entrant: @entrant)
    visit events_entrance_campaign_entrant_path(@campaign, @entrant)
    within('table') do
      expect(page).to have_content(event.name)
    end
  end

  scenario 'Может добавить абитуриенту вступительное испытание' do
    event = create(:entrance_event, campaign: @campaign)
    visit events_entrance_campaign_entrant_path(@campaign, @entrant)
    select "#{event.name_with_date}", from: 'entrance_event_entrant_entrance_event_id'
    click_button 'Добавить'
    within('table') do
      expect(page).to have_content(event.name)
    end
  end

  scenario 'Может удалять запись абитуриента на мероприятие', js: true, driver: :webkit do
    page.driver.browser.accept_js_confirms
    event = create(:entrance_event)
    create(:event_entrant, event: event, entrant: @entrant)
    visit events_entrance_campaign_entrant_path(@campaign, @entrant)
    click_link 'Удалить'
    expect(page).to have_content('Абитуриент не записан ни на одно из мероприятий')
  end

  scenario 'Может отменить удаление записи', js: true, driver: :webkit do
    page.driver.browser.reject_js_confirms
    event = create(:entrance_event)
    create(:event_entrant, event: event, entrant: @entrant)
    visit events_entrance_campaign_entrant_path(@campaign, @entrant)
    click_link 'Удалить'
    within('table') do
      expect(page).to have_content(event.name)
    end
  end

  scenario 'Не может добавить абитуриенту несколько записей на одно мероприятие' do
    event = create(:entrance_event)
    create(:event_entrant, event: event, entrant: @entrant)
    visit events_entrance_campaign_entrant_path(@campaign, @entrant)
    expect {
      select "#{event.name_with_date}", from: 'entrance_event_entrant_entrance_event_id'
    }.to raise_error
  end

end