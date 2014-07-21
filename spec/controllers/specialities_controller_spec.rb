require 'rails_helper'

describe SpecialitiesController, type: :controller do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @speciality = FactoryGirl.create(:speciality)
        get :index
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:index)
      end

      it 'в выводе должна присутствовать тестовая специальность' do
        expect(assigns(:specialities)).to include(@speciality)
      end
    end

    describe 'GET #new' do
      before :each do
        get :new
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:new)
      end

      it 'должен содержать новую запись' do
        expect(assigns(:speciality).new_record?).to be_truthy
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
