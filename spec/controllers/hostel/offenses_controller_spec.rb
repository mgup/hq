require 'spec_helper'

describe Hostel::OffensesController do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        get :index
      end
      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
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
        assigns(:hostel_offense).new_record?.should be_true
      end
    end

    describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          Offense.any_instance.should_receive(:save).and_return(true)
          post :create, hostel_offense: {}
        end

        it 'должен создавать новый департамент' do
          flash[:notice].should_not be_nil
        end

        it 'должно происходить перенаправление на страницу со структурой университета' do
          response.should redirect_to hostel_offenses_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          Offense.any_instance.should_receive(:save).and_return(false)
          post :create, hostel_offense: {}
          response.should render_template :new
        end
      end
    end

    describe 'PUT #update' do
      before :each do
        @offense = FactoryGirl.create(:hostel_offense)
      end
      context 'в случае успешного изменения' do
        before :each do
          Offense.any_instance.should_receive(:update).and_return(true)
          put :update, id: @updated, hostel_offense: {}
        end

        it 'должен находить правильного пользователя' do
          assigns(:hostel_offense).should eq(@updated)
        end

        it 'должен переходить на страницу со структурой университета' do
          flash[:notice].should_not be_nil
          response.should redirect_to hostel_offenses_path
        end

      end
    end

    

  context 'для не авторизованных пользователей' do
    it 'должен быть переход на страницу авторизации' do
      sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
    end
  end
end