require 'spec_helper'

describe DashboardController do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      it 'должен выполняться успешно' do
        get :index
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        get :index
        response.should render_template(:index)
      end
    end
  end

  #context 'для пользователей, не являющихся разработчиками,' do
  #  it 'должен быть переход на главную страницу' do
  #    sign_in FactoryGirl.create(:user)
  #
  #    get :index
  #    response.should redirect_to(root_path)
  #  end
  #end

  context 'для не авторизованных пользователей' do
    it 'должен быть переход на страницу авторизации' do
      sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
    end
  end
end