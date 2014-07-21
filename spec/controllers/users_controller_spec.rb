require 'rails_helper'

describe UsersController, type: :controller do
  context 'неавторизованный пользователь' do
    it 'должен перенаправляться на страницу авторизации' do
      sign_out :user

      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'авторизованный администратор' do
    before :each do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'при запросе списка пользователей' do
      before :each do
        @another_user = create(:user)
        get :index
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу со списком пользователей' do
        expect render_template(:index)
      end

      it 'должен получить список пользователей' do
        expect(assigns(:users)).to include(@user)
        expect(assigns(:users)).to include(@another_user)
      end
    end

    describe 'при создании пользователя' do
      before :each do
        get :new
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу создания пользователя' do
        expect render_template(:new)
      end

      it 'должен получить заготовку для пользователя' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe 'при редактировании пользователя' do
      before :each do
        @user = create(:user)
        get :edit, id: @user.id
      end

      it 'должен получить ответ' do
        expect respond_with(:success)
      end

      it 'должен видеть страницу редактирования пользователя' do
        expect render_template(:edit)
      end

      it 'должен получить нужного пользователя' do
        expect(assigns(:user)).to eql(@user)
      end
    end
  end
end
