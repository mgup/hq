require 'rails_helper'

feature 'Список заявлений абитуриента' do
  background 'Сотрудник приёмной комисии' do
    @user = create(:user, :selection)
    User.current = @user

    as_user(@user)
    @campaign =  create(:campaign)
    tests = @campaign.competitive_groups.first.test_items
    3.times do
      tests << create(:entrance_test_item, competitive_group: @campaign.competitive_groups.first)
    end

    exams = []
    tests.each do |test|
      exams << test.exam
    end

    @entrant = create(:entrant, campaign: @campaign)
    exams.each do |exam|
      create(:exam_result, exam: exam, entrant: @entrant, score: 80)
    end
    @application = create(:entrance_application, campaign: @campaign, entrant: @entrant)
    @entrant = @application.entrant
  end

  scenario 'Должен видеть список заявлений абитуриента' do
    visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
    expect(page).to have_content(@application.number)
  end

  # scenario 'Должен видеть возможные заявления' do
  #   visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
  #   expect(page).to have_content(@campaign.competitive_groups.first.name)
  # end

  # scenario 'Может создать новое заявление' do
  #   visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
  #   click_button 'Создать заявление'
  #   expect(@entrant.applications.length).to eq(2)
  # end

  # scenario 'Может создать новое заявление с подлинником', js: true, driver: :webkit do
  #   visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
  #   check 'Оригинал документа об образовании'
  #   click_button 'Создать заявление'
  #   expect(page).to have_content('Получен подлинник документа.')
  # end

  scenario 'Не должен видеть заявления других абитуриентов' do
    other_application = create(:entrance_application, campaign: @campaign, entrant: create(:entrant, campaign: @campaign))
    visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
    expect(page).not_to have_content(other_application.number)
  end

  # TODO Нужно придумать, как "нажимать" кнопки без текста

  # scenario 'Может распечатать все заявления абитуриента' do
  #   visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
  #   click_link 'Распечатать все заявления'
  #   expect(current_path).to eq(print_all_entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant))
  # end

  # scenario 'Может распечатать отдельное заявление абитуриента' do
  #   visit entrance_campaign_entrant_applications_path(campaign_id: @campaign, entrant_id: @entrant)
  #   click_link 'Распечатать заявление'
  #   expect(current_path).to eq(print_entrance_campaign_entrant_application_path(campaign_id: @campaign, entrant_id: @entrant, id: @application))
  # end

end