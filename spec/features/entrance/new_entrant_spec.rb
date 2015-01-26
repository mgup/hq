require 'rails_helper'

feature 'Добавление нового абитуриента' do
  background 'Сотрудник приёмной комиссии' do
    user = create(:user, :selection)
    Thread.current[:user] = user
    as_user(user)
    @campaign = create(:campaign)
    [3,4,5,6,7,8,9,16].each do |i|
      create(:entrance_document_type, id: i) if Entrance::DocumentType.where(id: i).empty?
    end
    @exam = create(:entrance_exam)
  end

  scenario 'сохраняет нового абитуриента с корректными данными' do
    visit new_entrance_campaign_entrant_path(campaign_id: @campaign)
    fill_in 'entrance_entrant[last_name]', with: 'Example'
    fill_in 'entrance_entrant[first_name]', with: 'First'
    choose('женский')
    fill_in 'entrance_entrant[birthday]', with: '14.07.1996'
    fill_in 'entrance_entrant[birth_place]', with: 'Birth place'
    fill_in 'entrance_entrant[pseries]', with: '1234'
    fill_in 'entrance_entrant[pnumber]', with: '123456'
    fill_in 'entrance_entrant[pdepartment]', with: 'Passport department'
    fill_in 'entrance_entrant[pdate]', with: '28.07.2010'
    fill_in 'entrance_entrant[azip]', with: '987654'
    fill_in 'entrance_entrant[aaddress]', with: 'Entrant address'
    fill_in 'entrance_entrant[phone]', with: '+7 999 123-45-67'
    fill_in 'entrance_entrant[edu_document_attributes][organization]', with: 'Entrant institution'
    fill_in 'entrance_entrant[edu_document_attributes][graduation_year]', with: '2014'
    fill_in 'entrance_entrant[edu_document_attributes][number]', with: '2356gsf76fg'
    fill_in 'entrance_entrant[edu_document_attributes][date]', with: '20.06.2014'
    click_button('Сохранить')
    within 'h1' do
      expect(page).to have_content('Заявления')
    end
    expect(page).to have_content('Example')
    expect(page).to have_content('First')
  end

  scenario 'пытается сохранить нового абитуриента с некорректными данными', js: true, driver: :webkit do
    visit new_entrance_campaign_entrant_path(campaign_id: @campaign)
    click_button('Сохранить')

    expect(page).to have_content('Это поле необходимо заполнить.')
  end

  scenario 'может добавить вступительные испытания', js: true, driver: :webkit do
    visit new_entrance_campaign_entrant_path(campaign_id: @campaign)
    click_link 'Добавить вступительное испытание'

    expect(page).to have_css('.fields')
    expect(page).to have_content('Удалить вступительное испытание')
  end
end