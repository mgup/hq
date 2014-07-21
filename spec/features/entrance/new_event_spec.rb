require 'rails_helper'

feature 'Добавление нового вступительного испытания' do
  background 'Разработчик' do
    user = create(:user, :developer)
    Thread.current[:user] = user
    as_user(user)
    @campaign = create(:campaign)
  end

  scenario 'сохраняет новое вступительное испытание с корректными данными' do
    visit new_entrance_campaign_event_path(campaign_id: @campaign)
    fill_in 'entrance_event[name]', with: 'Example'
    fill_in 'entrance_event[date]', with: '20.06.2014'
    click_button('Сохранить')
    within 'h1' do
      expect(page).to have_content('Мероприятия с абитуриентами')
    end
    within 'table' do
      expect(page).to have_content('Example')
      expect(page).to have_content('20 июня 2014')
    end
  end

  scenario 'может отменить создание нового вступительного испытания' do
    visit new_entrance_campaign_event_path(campaign_id: @campaign)
    fill_in 'entrance_event[name]', with: 'Example'
    click_link('Отмена')
    within 'h1' do
      expect(page).to have_content('Мероприятия с абитуриентами')
    end
    within 'table' do
      expect(page).not_to have_content('Example')
    end
  end

end