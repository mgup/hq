require 'rails_helper'

describe RolesController, type: :controller do
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

      it 'должен инициировать массив с ролями' do
        developer_role = Role.first

        get :index
        expect(assigns(:roles)).to eq([developer_role])
      end

      context 'при оторажении ролей' do
        it 'должны выводиться неактивные роли' do
          developer_role = Role.first
          role = FactoryGirl.create(:role, title: '1', active: false)

          get :index
          expect(assigns(:roles)).to eq([role, developer_role])
        end

        it 'должна быть сортировка по названию роли' do
          developer_role = Role.first
          role = FactoryGirl.create(:role, title: '1')

          get :index
          expect(assigns(:roles)).to eq([role, developer_role])
        end
      end
    end

    describe 'GET "new"' do
      it 'инициализирует пустую роль' do

      end
    end
  end

  context 'для пользователей, не являющихся разработчиками,' do
    it 'должен быть переход на главную страницу' do
      sign_in FactoryGirl.create(:user)

      get :index
      expect(response).to redirect_to(root_path)
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
