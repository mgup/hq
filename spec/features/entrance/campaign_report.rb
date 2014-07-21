require 'rails_helper'

feature 'Статистика' do
  background 'Сотрудник приёмной комисии' do
    create(:education_form, id: 10)
    create(:education_form, id: 11)
    create(:education_form, id: 12)
    create(:education_source, id: 15)
    create(:education_source, id: 14)
    user = create(:user, :selection)
    Thread.current[:user] = user
    as_user(user)
    @campaign =  create(:campaign)
    cg = create(:competitive_group_item, :budget_o, direction: create(:direction, department: create(:department, :faculty)),
                competitive_group: create(:competitive_group, campaign: @campaign))
    @applications = []
    @applications_original = []
    4.times do
      @applications << create(:entrance_application, campaign: @campaign,
                              competitive_group_item: cg)
    end
    2.times do
      @applications_original << create(:entrance_application, :original, campaign: @campaign,
                              competitive_group_item: cg)
    end
  end

  scenario 'При загрузке страницы должен видеть общее количество заявлений и число заявлений с оригиналом' do
    visit report_entrance_campaign_path(id: @campaign)
    expect(page).to have_content("#{@applications.size + @applications_original.size} (#{@applications_original.size})")
  end

end