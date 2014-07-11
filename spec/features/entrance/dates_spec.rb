require 'rails_helper'

feature 'Сроки проведения' do
  background 'Разработчик' do
    @campaign =  create(:campaign)
    @date = create(:entrance_date, campaign: @campaign)
    as_user(create(:user, :developer))
  end

  scenario 'Должен видеть сроки проведения текущей приёмной компании' do
    visit entrance_campaign_dates_path(campaign_id: @campaign)
    expect(page).to have_content(@date.description)
  end

  scenario 'Не должен видеть сроков проведения другой компании' do
    other_date = create(:entrance_date, campaign: create(:campaign))
    visit entrance_campaign_dates_path(campaign_id: @campaign)
    expect(page).not_to have_content(other_date.description)
  end

end