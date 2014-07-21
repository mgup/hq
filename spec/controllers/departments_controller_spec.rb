require 'rails_helper'

describe DepartmentsController, type: :controller do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @department = FactoryGirl.create(:department)
        get :index
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:index)
      end

      it 'в выводе должна присутствовать тестовая дисциплина' do
        expect(assigns(:departments)).to include(@department)
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
        expect(assigns(:department).new_record?).to be_truthy
      end
    end

    describe 'GET "edit"' do
      before :each do
        @edited = FactoryGirl.create(:department)
        get :edit, id: @edited.id
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:edit)
      end

      it 'должен находить правильного пользователя' do
        expect(assigns(:department)).to eq(@edited)
      end
    end

    describe 'POST #create' do
      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          allow(Department).to receive(:save).and_return(false)

          post :create, department: {}
          expect(response).to render_template :new
        end
      end
    end

    describe 'PUT #update' do
      before :each do
        @updated = FactoryGirl.create(:department)
      end

      context 'в случае успешного изменения' do
        before :each do
          allow(Department).to receive(:update).and_return(true)

          put :update, id: @updated, department: {}
        end

        it 'должен находить правильного пользователя' do
          expect(assigns(:department)).to eq(@updated)
        end

        it 'должен переходить на страницу со структурой университета' do
          expect(flash[:notice]).not_to be_nil
          expect(response).to redirect_to departments_path
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @deleted = FactoryGirl.create(:department)
        expect { delete :destroy, id: @deleted }
          .to change { Department.count }.by(-1)
      end

      it 'должен находить правильный департамент' do
        expect(assigns(:department)).to eq(@deleted)
      end

      it 'должен перенаправлять на страницу со структурой университета' do
        expect(response).to redirect_to departments_path
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
