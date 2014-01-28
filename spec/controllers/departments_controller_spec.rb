require 'spec_helper'

describe DepartmentsController do
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
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

      it 'в выводе должна присутствовать тестовая дисциплина' do
        assigns(:departments).should include(@department)
      end
    end

    describe 'GET #new' do
      before :each do
        get :new
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:new)
      end

      it 'должен содержать новую запись' do
        assigns(:department).new_record?.should be_true
      end
    end

    describe 'GET "edit"' do
      before :each do
        @edited = FactoryGirl.create(:department)
        get :edit, id: @edited.id
      end
      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template :edit
      end

      it 'должен находить правильного пользователя' do
        assigns(:department).should eq(@edited)
      end
    end

    describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          Department.any_instance.should_receive(:save).and_return(true)
          post :create, department: {}
        end

        it 'должен создавать новый департамент' do
          flash[:notice].should_not be_nil
        end

        it 'должно происходить перенаправление на страницу со структурой университета' do
          response.should redirect_to departments_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          Department.any_instance.should_receive(:save).and_return(false)
          post :create, department: {}
          response.should render_template :new
        end
      end
    end

    describe 'PUT #update' do
      before :each do
        @updated = FactoryGirl.create(:department)
      end
      context 'в случае успешного изменения' do
        before :each do
          Department.any_instance.should_receive(:update).and_return(true)
          put :update, id: @updated, department: {}
        end

        it 'должен находить правильного пользователя' do
          assigns(:department).should eq(@updated)
        end

        it 'должен переходить на страницу со структурой университета' do
          flash[:notice].should_not be_nil
          response.should redirect_to departments_path
        end

      end

      #context 'в случае неудачи' do
      #  it 'должен перенаправлять на редактирование' do
      #    put :update, id: @updated, department: { name: '', abbreviation: '' }
      #    response.should render_template :edit
      #  end
      #end
    end

    describe 'DELETE #destroy' do
      before :each do
        @deleted = FactoryGirl.create(:department)
        expect {
          delete :destroy, id: @deleted
        }.to change { Department.count }.by(-1)
      end

      it 'должен находить правильный департамент' do
        assigns(:department).should eq(@deleted)
        @deleted.id == nil
      end
      it 'должен перенаправлять на страницу со структурой университета' do
        response.should redirect_to departments_path
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