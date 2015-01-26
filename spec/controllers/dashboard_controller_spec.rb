require 'rails_helper'

describe DashboardController, type: :controller do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      it 'должен выполняться успешно' do
        get :index
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  context 'для не авторизованных пользователей' do
    it 'должен быть переход на страницу авторизации' do
      sign_out :user

      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
