require 'spec_my'

describe UsersController do
  context 'неавторизованный пользователь' do
    it 'должен перенаправляться на страницу авторизации' do
      sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
    end
  end

  context 'авторизованный пользователь без прав администратора' do

  end

  context 'авторизованный администратор' do
    before :each do
      @user = create(:user, :developer)
      sign_in @user
    end
