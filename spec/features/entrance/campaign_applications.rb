require 'rails_helper'

feature 'Список заявлений текущей приёмной компании' do
  background 'Сотрудник приёмной комисии' do
    user = create(:user, :selection)
    Thread.current[:user] = user
    as_user(user)
    @campaign =  create(:campaign)
    @applications = []
    create(:education_form, id: 10)
    create(:education_form, id: 11)
    create(:education_form, id: 12)
    create(:education_source, id: 15)
    create(:education_source, id: 14)
    4.times do
      @applications << create(:entrance_application, campaign: @campaign,
                              competitive_group_item: create(:competitive_group_item, :budget_o,
                                                             competitive_group: create(:competitive_group, campaign: @campaign)))
    end
  end

  scenario 'Должен видеть список заявлений, соответствующий фильтрам' do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id})
    expect(page).to have_content(@applications[0].number)
  end

  scenario 'Не должен видеть список заявлений, не соответствующий фильтрам' do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id})
    expect(page).not_to have_content(@applications[1].number)
  end

  scenario 'При изменении в фильтрах направления должен увидеть новый список заявлений', js: true, driver: :webkit do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id})
    select "#{@applications[2].competitive_group_item.direction.description}", from: 'direction'
    expect(page).to have_content(@applications[2].number)
  end

  scenario 'При отсутствии заявлений по данным параметрам должен видеть сообщение "Нет ни одного заявления"', js: true, driver: :webkit do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id})
    select 'заочная', from: 'form'
    select 'платное', from: 'payment'
    expect(page).to have_content('Нет ни одного заявления')
  end

  scenario 'Может распечатать соответствующий фильтрам список заявлений' do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id})
    click_link 'Распечатать'
    expect(current_url).to eq(applications_entrance_campaign_url(id: @campaign, format: :pdf,
                                                                   params: {direction: @applications[0].competitive_group_item.direction.id,
                                                                            date: I18n.l(Date.today), form: 11, payment: 14}))
  end

end