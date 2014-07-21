require 'rails_helper'

feature 'Регистрационный журнал' do
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
                              competitive_group_item: create(:competitive_group_item, :budget_o, direction: create(:direction),
                                                             competitive_group: create(:competitive_group, campaign: @campaign)))
    end
  end

  scenario 'При загрузке страницы должен видеть список заявлений всех направлений текущей приёмной компании' do
    visit register_entrance_campaign_path(id: @campaign)
    [0,1,2,3].each do |i|
      expect(page).to have_content(@applications[i].number)
     end
  end

  scenario 'При загрузке страницы не должен видеть заявления другой приёмной компании' do
    other_application = create(:entrance_application, campaign: create(:campaign))
    visit register_entrance_campaign_path(id: @campaign)
    expect(page).not_to have_content(other_application.number)
  end

  scenario 'При изменении в фильтрах направления должен увидеть новый список заявлений', js: true, driver: :webkit do
    visit register_entrance_campaign_path(id: @campaign)
    select "#{@applications[1].competitive_group_item.direction.description}", from: 'direction'
    expect(page).to have_content(@applications[1].number)
    expect(page).not_to have_content(@applications[2].entrant.contacts)
  end


end