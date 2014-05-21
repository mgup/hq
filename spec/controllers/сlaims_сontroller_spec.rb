require 'spec_helper'

describe ClaimsController do
  
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

    end

        describe 'POST #create' do
          context 'в случае успешного создания' do
            before :each do
           EventDateClaim.any_instance.should_receive(:save).and_return(true)
            post :create, claim: {}
        end

        it 'должен создавать новую заметку' do
          flash[:notice].should_not be_nil
        end

        it 'должно происходить перенаправление на страницу со структурой ' do
          response.should redirect_to actual_events_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          EventDateClaim.any_instance.should_receive(:save).and_return(false)
          post :create, claim: {}
          response.should render_template :new
        end
      end
    end







end
