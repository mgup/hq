require 'spec_helper'

describe ClaimsController do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @event = FactoryGirl.create(:event)
        get :index
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

      it 'в выводе должна присутствовать заявка' do
        assigns(:event).should include(@event)
      end
    end

    describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          EventDateClaim.any_instance.should_receive(:save).and_return(true)
          post :create, event: {}
        end

        it 'должен создавать новую заявку' do
          flash[:notice].should_not be_nil
        end

        it 'должно происходить перенаправление на страницу со структурой университета' do
          response.should redirect_to actual_events_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          EventDateClaim.any_instance.should_receive(:save).and_return(false)
          post :create, event: {}
          response.should render_template :new
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
end