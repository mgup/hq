require 'rails_helper'

describe Entrance::ApplicationsController, type: :controller do
  context 'авторизованный сотрудник приёмной комиссии' do
    before :each do
      @user = create(:user, :selection)
      sign_in @user
      User.current = @user

      @campaign = create(:campaign)
      @entrant = create(:entrant, campaign: @campaign)
    end

    describe 'при запросе списка заявлений абитуриента' do
      before :each do
        get :index, campaign_id: @campaign, entrant_id: @entrant
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу со списком заявлений' do
        expect render_template(:index)
      end
    end

  end
end