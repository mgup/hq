require 'rails_helper'

describe StudentsController, type: :controller do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @student = create(:student)
        get :index
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:index)
      end

      it 'в выводе должен присутствовать тестовый студент' do
        expect(assigns(:students)).to include(@student)
      end
    end

    describe 'GET "show"' do
      before :each do
        @shown = create(:student)
        get :show, id: @shown.id
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:show)
      end

      it 'должен находить правильного студента' do
        expect(assigns(:student)).to eq(@shown)
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
