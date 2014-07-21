require 'rails_helper'

describe Entrance::DatesController, type: :controller do
  context 'авторизованный сотрудник приёмной комиссии' do
    before :each do
      @user = create(:user, :selection)
      sign_in @user
      @campaign = create(:campaign)
    end

    describe 'при запросе информации о сроках проведения' do
      before :each do
        get :index, campaign_id: @campaign
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу со сроками проведения' do
        expect render_template(:index)
      end

      context 'получая информацию о сроках' do

        it 'должен видеть даты текущей приёмной компании' do
          date = create(:entrance_date, campaign: @campaign)
          expect(@campaign.dates).to include(date)
        end

        it 'не должен видеть даты приёмной компании другого года' do
          date = create(:entrance_date, campaign: create(:campaign))
          expect(@campaign.dates).not_to include(date)
        end

      end
    end

  end
end