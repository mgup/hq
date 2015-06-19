require 'rails_helper'

describe Purchase::GoodsController, type: :controller do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @purchase_good = FactoryGirl.create(:purchase_good)
        get :index
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:index)
      end

      it 'в выводе должна присутствовать тестовая специальность' do
        # good = assigns(:purchase_goods)
        expect(assigns(:purchase_goods).to include(@purchase_good))
      end
    end
  end
end