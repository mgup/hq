require 'rails_helper'

feature 'Список абитуриентов' do
  background 'Сотрудник приёмной комисии' do
    user = create(:user, :selection)
    Thread.current[:user] = user
    as_user(user)
    @campaign = create(:campaign)
    @entrant = create(:entrant, campaign: @campaign)
  end

  scenario 'Должен видеть список абитуриентов текущей компании' do
    visit entrance_campaign_entrants_path(campaign_id: @campaign)
    expect(page).to have_content(@entrant.last_name)
  end

  scenario 'Не должен видеть абитуриентов другой компании' do
    other_entrant = create(:entrant, campaign: create(:campaign))
    visit entrance_campaign_entrants_path(campaign_id: @campaign)
    expect(page).not_to have_content(other_entrant.last_name)
  end

  scenario 'Может перейти к созданию абитуриента' do
    # Типы документов мы получаем из ФИС.
    26.times { create(:entrance_document_type) }

    visit entrance_campaign_entrants_path(campaign_id: @campaign)
    click_link 'Добавить абитуриента'
    expect(page).to have_selector('#new_entrance_entrant')
  end



  # scenario 'Может перейти к редактированию информации об абитуриенте' do
  #   visit entrance_campaign_entrants_path(campaign_id: @campaign)
  #   page.find("a[title='Редактировать']").click
  #
  #   expect(page).to have_css("#edit_entrance_entrant_#{@entrant.id}")
  #   within '.page-header' do
  #     expect(page).to have_content(@entrant.full_name)
  #   end
  # end
  #
  # scenario 'Может удалить абитуриента', js: true, driver: :webkit do
  #   visit entrance_campaign_entrants_path(campaign_id: @campaign)
  #   page.find("a[title='Удалить']").click
  #   page.driver.browser.accept_js_confirms
  #
  #   expect(page).not_to have_content(@entrant.last_name)
  # end
end