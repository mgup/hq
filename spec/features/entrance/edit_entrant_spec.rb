require 'rails_helper'

feature 'Редактирование абитуриента' do
  background 'Разработчик' do
    user = create(:user, :developer)
    Thread.current[:user] = user
    as_user(user)
    @campaign = create(:campaign)
    @entrant= create(:entrant, :with_exams, campaign: @campaign)
    create(:entrance_document_type, id: 3)
    create(:entrance_document_type, id: 4)
    create(:entrance_document_type, id: 5)
    create(:entrance_document_type, id: 6)
    create(:entrance_document_type, id: 7)
    create(:entrance_document_type, id: 8)
    create(:entrance_document_type, id: 16)
  end

  scenario 'видит данные абитуриента' do
    visit edit_entrance_campaign_entrant_path(campaign_id: @campaign, id: @entrant)
    expect(find('#entrance_entrant_last_name').value).to eq(@entrant.last_name)
    within 'h1' do
      expect(page).to have_content(@entrant.full_name)
    end
  end

end