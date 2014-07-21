require 'rails_helper'

describe Entrance::EntrantsController, type: :controller do
  context 'авторизованный сотрудник приёмной комиссии' do
    before :each do
      @user = create(:user, :selection)
      sign_in @user
      @campaign = create(:campaign)
    end

    describe 'при запросе списка абитуриентов' do
      before :each do
        get :index, campaign_id: @campaign
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу со списком абитуриентов' do
        expect render_template(:index)
      end

      context 'получая список абитуриентов' do

        it 'должен видеть абитуриентов этого года' do
          entrant = create(:entrant, campaign: @campaign)
          expect(assigns(:entrants)).to include(entrant)
        end

        it 'не должен видеть абитуриентов другого года' do
          entrant = create(:entrant, campaign: create(:campaign))
          expect(assigns(:entrants)).not_to include(entrant)
        end

      end
    end

    describe 'при создании абитуриента' do
      before :each do
        get :new, campaign_id: @campaign
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу создания абитуриента' do
        expect render_template(:new)
      end

      it 'должен получить заготовку для абитуриента' do
        expect(assigns(:entrant)).to be_a_new(Entrance::Entrant)
      end
    end

    #Идет преобразование строки в число и возникает ошибка ???
    # describe 'при сохранении нового абитуриента' do
    #   context 'при отсутствии ошибок в данных' do
    #     before :each do
    #       @entrant_attrs = build(:entrant, campaign: @campaign).attributes
    #       raise @entrant_attrs.inspect
    #     end
    #
    #     it 'должен вызывать создание абитуриента' do
    #       expect { post :create, campaign_id: @campaign, entrance_entrant: @entrant_attrs }
    #       .to change { Entrance::Entrant.count }.by(1)
    #     end
    #
    #     it 'должен переходить на страницу со списком абитуриентов' do
    #       post :create, campaign_id: @campaign, entrance_entrant: @entrant_attrs
    #       expect(response).to redirect_to(entrance_campaign_entrants_path(campaign: @campaign))
    #     end
    #   end
    # end

    describe 'при редактировании абитуриента' do
      before :each do
        @entrant = create(:entrant, campaign: @campaign)
        get :edit, campaign_id: @campaign, id: @entrant
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу редактировании абитуриента' do
        expect render_template(:edit)
      end

      it 'должен получать нужную запись' do
        expect(assigns(:entrant)).to eql(@entrant)
      end
    end

    # TODO При удалении нужно учитывать права доступа.
    # describe 'при удалении абитуриента' do
    #   before :each do
    #     @entrant = create(:entrant, campaign: @campaign)
    #   end
    #
    #   it 'должен удалить абитуриента' do
    #     expect { delete :destroy, campaign: @campaign, id: @entrant }.
    #       to change { Entrance::Entrant.count }.by(-1)
    #   end
    #
    #   it 'должен перейти на страницу со списком абитуриентов' do
    #     delete :destroy, campaign: @campaign, id: @entrant
    #     expect(response).to redirect_to(entrance_campaign_entrants_path(campaign: @campaign))
    #   end
    # end
  end
end