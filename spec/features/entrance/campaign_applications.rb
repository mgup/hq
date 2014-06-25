require 'spec_helper'

feature 'Список заявлений текущей приёмной компании' do
  background 'Сотрудник приёмной комисии' do
    user = create(:user, :selection)
    Thread.current[:user] = user
    as_user(user)
    @campaign =  create(:campaign)
    @applications = []
    create(:education_form)
    create(:education_source)
    4.times do
      @applications << create(:entrance_application, campaign: @campaign, competitive_group_item: create(:competitive_group_item, :budget_o))
    end
  end

  scenario 'Должен видеть список заявлений, соответствующий фильтрам' do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id,
                                              form: 1, payment: 1})
    expect(page).to have_content(@applications[0].number)
  end

  scenario 'Не должен видеть список заявлений, не соответствующий фильтрам' do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id,
                                                       form: 1, payment: 1})
    expect(page).not_to have_content(@applications[1].number)
  end

  scenario 'Может распечатать соответствующий фильтрам список заявлений' do
    visit applications_entrance_campaign_path(id: @campaign,
                                              params: {direction: @applications[0].competitive_group_item.direction.id,
                                                       form: 1, payment: 1})
    click_link 'Распечатать'
    expect(current_url).to eq(applications_entrance_campaign_url(id: @campaign, format: :pdf,
                                                                   params: {direction: @applications[0].competitive_group_item.direction.id,
                                                                            date: I18n.l(Date.today), form: 1, payment: 1}))
  end

end